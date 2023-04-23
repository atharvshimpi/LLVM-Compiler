#include "ast.hh"

#include <string>
#include <vector>

#define MAX_SHORT_VAL 32767
#define MAX_INT_VAL 2147483647

NodeBinOp::NodeBinOp(NodeBinOp::Op ope, Node *leftptr, Node *rightptr, int val)
{
    type = BIN_OP;
    op = ope;
    left = leftptr;
    right = rightptr;
    test = val;
}

std::string NodeBinOp::to_string()
{
    std::string out = "(";
    std::string overflow = "";
    long long l = 1, r = 1;
    if (left->to_string()[0] >= '0' && left->to_string()[0] <= '9')
        l = stoll(left->to_string());
    if (right->to_string()[0] >= '0' && right->to_string()[0] <= '9')
        r = stoll(right->to_string());
    switch (op)
    {
    case PLUS:
    {
        out += " +";

        if (test == 1 && l + r > MAX_SHORT_VAL)
        {
            overflow += "Short Overflow";
        }
        if (test == 2 && l + r > MAX_INT_VAL)
        {
            overflow += "Integer Overflow";
        }
        break;
    }
    case MINUS:
    {
        out += " -";

        if (test == 1 && l - r > MAX_SHORT_VAL)
        {
            overflow += "Short Overflow";
        }
        if (test == 2 && l - r > MAX_INT_VAL)
        {
            overflow += "Integer Overflow";
        }
        break;
    }
    case MULT:
    {
        out += " *";
        if (test == 1 && l * r > MAX_SHORT_VAL)
        {
            overflow += "Short Overflow";
        }
        if (test == 2 && l * r > MAX_INT_VAL)
        {
            overflow += "Integer Overflow";
        }
        break;
    }
    case DIV:
    {
        out += " /";
        if (test == 1 && l / r > MAX_SHORT_VAL)
        {
            overflow += "Short Overflow";
        }
        if (test == 2 && l / r > MAX_INT_VAL)
        {
            overflow += "Integer Overflow";
        }
        break;
    }
    }
    out += ' ' + left->to_string() + ' ' + right->to_string() + " )";

    if (overflow.length() > 0)
    {
        return overflow;
    }
    return out;
}

NodeInt::NodeInt(int val)
{
    type = INT_LIT;
    value = val;
}

std::string NodeInt::to_string()
{
    return std::to_string(value);
}

NodeShort::NodeShort(short val)
{
    type = INT_LIT;
    value = val;
}

std::string NodeShort::to_string()
{
    return std::to_string(value);
}

NodeLong::NodeLong(long long val)
{
    type = INT_LIT;
    value = val;
}

std::string NodeLong::to_string()
{
    return std::to_string(value);
}

NodeStmts::NodeStmts()
{
    type = STMTS;
    list = std::vector<Node *>();
}

void NodeStmts::push_back(Node *node)
{
    list.push_back(node);
}

std::string NodeStmts::to_string()
{
    std::string out = "(begin";
    for (auto i : list)
    {
        out += " " + i->to_string();
    }

    out += ')';

    return out;
}

NodeAssn::NodeAssn(std::string id, Node *expr)
{
    type = ASSN;
    identifier = id;
    expression = expr;
}

std::string NodeAssn::to_string()
{
    return "(let " + identifier + " " + expression->to_string() + ")";
}

NodeDebug::NodeDebug(Node *expr)
{
    type = DBG;
    expression = expr;
}

std::string NodeDebug::to_string()
{
    return "(dbg " + expression->to_string() + ")";
}

NodeIdent::NodeIdent(std::string ident)
{
    identifier = ident;
}
std::string NodeIdent::to_string()
{
    return identifier;
}
NodeIfElse::NodeIfElse(Node *cond, Node *tBody, Node *fBody)
{
    condition = cond;
    ifBody = tBody;
    elseBody = fBody;
}

std::string NodeIfElse::to_string()
{
    std::string s = condition->to_string();
    int c = 0;
    for (auto i : s)
    {
        if (i >= 'a' && i <= 'z')
            c = 1;
        else if (i >= 'A' && i <= 'Z')
            c = 1;
    }
    std::string out;
    if (c == 0 && s != "0")
    {
        out += "\n(if-else " + condition->to_string() + " \n";
        out += ifBody->to_string() + "\n";
    }

    out += elseBody->to_string() + "\n)";
    return out;
}