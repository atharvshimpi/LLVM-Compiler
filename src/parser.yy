%define api.value.type { ParserValue }
 
%code requires {
#include <iostream>
#include <vector>
#include <string>
#include <unordered_map>
#include <stdio.h>
#include <string.h>
#include <bits/stdc++.h>
 
#include "parser_util.hh"
#include "symbol.hh"
#include "symbol1.hh"
#include "symbol2.hh"
#include "utils.hh"
using namespace std;
}
 
%code {
 
#include <cstdlib>
#include <bits/stdc++.h>
using namespace std;
extern int yylex();
extern int yyparse();
int level=0,d=0;
extern NodeStmts* final_values;
 

int flag=0;
int yyerror(std::string msg);

}
 
%token TPLUS TDASH TSTAR TSLASH
%token <lexeme> TINT_LIT TIDENT TINT_TYPE TSHORT_TYPE TLONG_TYPE 
%token TLET TDBG
%token TSCOL TLPAREN TRPAREN TEQUAL TCOLON
%token TIF TELSE TLCURL TRCURL TFUN TMAIN
 
 
%type <node> ExprInt ExprShort ExprLong Expr Stmt IF TTYPE LCurlTxt RCurlTxt FuncDef
%type <stmts> Program StmtList ParamList 
 
%left TPLUS TDASH
%left TSTAR TSLASH
 
%%
 
Program :                
        { final_values = nullptr; }
        | StmtList TSCOL 
        {   
             final_values = $1; }
       
         | IF {
            $$=new NodeStmts();
            $$->push_back($1);
            final_values=$$;
         }
         | StmtList TSCOL IF
         {
            $$=new NodeStmts();
            $$->push_back($1);
            $$->push_back($3);
            final_values=$$;
         }
         
         | StmtList TSCOL TFUN TMAIN TLPAREN TRPAREN  TCOLON TTYPE TLCURL StmtList TRCURL StmtList TSCOL
         {
            $$=new NodeStmts();
            $$->push_back($1);
            $$->push_back($10);
            $$->push_back($12);
            final_values=$$;
         }
         | StmtList TSCOL TFUN TMAIN TLPAREN TRPAREN  TCOLON TTYPE TLCURL StmtList  TSCOL TRCURL StmtList TSCOL
         {
            $$=new NodeStmts();
            $$->push_back($1);
            $$->push_back($10);
            $$->push_back($13);
            final_values=$$;
         }
         | StmtList TSCOL TFUN TMAIN TLPAREN TRPAREN  TCOLON TTYPE TLCURL StmtList  TSCOL TRCURL StmtList 
         {
            $$=new NodeStmts();
            $$->push_back($1);
            $$->push_back($10);
            $$->push_back($13);
            final_values=$$;
         }
         | StmtList TSCOL TFUN TMAIN TLPAREN TRPAREN  TCOLON TTYPE TLCURL StmtList TRCURL StmtList 
         {
            $$=new NodeStmts();
            $$->push_back($1);
            $$->push_back($10);
            $$->push_back($12);
            final_values=$$;
         }
         
	    ;
 
StmtList :
         
         Stmt                
         { $$ = new NodeStmts(); $$->push_back($1); }
	     | StmtList TSCOL Stmt 
         { $$->push_back($3); }
        
         | StmtList Stmt
         {
            $$->push_back($2);
         }
         | StmtList TSCOL IF
         {
            $$->push_back($3);
         }
	     ;
        
TTYPE: TINT_TYPE{} | TLONG_TYPE{} | TSHORT_TYPE{};

Stmt : TLET TIDENT TCOLON TSHORT_TYPE TEQUAL ExprShort
     {
        if(symbolTable2.contains($2)) {
            // tried to redeclare variable, so error
            yyerror("tried to redeclare variable.\n");
        } else {
            std::string s=$6->to_string();

            long long ans_i=FindAns(s,0);
            if(ans_i==0)
            {
                yyerror("TypeCasting error.\n");
            }
            else{
            if(checkNotAlpha(s))
            {
                long long ans=solver(s);
                if(ans>32767){
                    yyerror("Short Overflow.\n");
                }
                symbolTable2.insert($2,ans);
                symbolTable.insert($2);
                symbolTable1.insert($2,{ans,0});
                Node* nd = new NodeLong(ans);
                $$ = new NodeAssn($2,nd);
            }
            else
            {
                symbolTable.insert($2);
                long long ans=ValueSolver(s);
                symbolTable1.insert($2,{ans,0});
                if(ans>32767){
                    yyerror("Short Overflow.\n");
                }
                symbolTable2.insert($2,ans);
                $$ = new NodeAssn($2, $6);
            }
            }
        }
        
     }
     |TLET TIDENT TCOLON TINT_TYPE TEQUAL ExprInt
     {
        if(symbolTable2.contains($2)) {
            // tried to redeclare variable, so error
            yyerror("tried to redeclare variable.\n");
        } else {
            std::string s=$6->to_string();
            long long ans_i=FindAns(s,1);
            if(ans_i==0)
            {
                yyerror("TypeCasting error.\n");
            }
            else{
            if(checkNotAlpha(s))
            {
                long long ans=solver(s);
                if(ans>2147483647){
                    yyerror("Integer Overflow.\n");
                }
                
                symbolTable2.insert($2,ans);
                symbolTable.insert($2);
                symbolTable1.insert($2,{ans,1});
                Node* nd = new NodeLong(ans);
                $$ = new NodeAssn($2,nd);
            }
            else
            {
                symbolTable.insert($2);
                
                long long ans=ValueSolver(s);
                symbolTable1.insert($2,{ans,1});
                symbolTable2.insert($2,ans);
                if(ans>2147483647){
                    yyerror("Integer Overflow.\n");
                }

                $$ = new NodeAssn($2, $6);
            }
            }
        }
       
     }
     |TLET TIDENT TCOLON TLONG_TYPE TEQUAL ExprLong
     {
        
        if(symbolTable2.contains($2)) {
            // tried to redeclare variable, so error
            yyerror("tried to redeclare variable.\n");
        } else {
            std::string s=$6->to_string();
            long long ans_i=FindAns(s,2);
            if(ans_i==0)
            {
                yyerror("TypeCasting error.\n");
            }
            else{
            if(checkNotAlpha(s))
            {
                long long ans=solver(s);
                symbolTable2.insert($2,ans);
                symbolTable.insert($2);
                symbolTable1.insert($2,{ans,2});
                Node* nd = new NodeLong(ans);

                $$ = new NodeAssn($2,nd);

            }
            else
            {
                symbolTable.insert($2);
                long long ans=ValueSolver(s);
                symbolTable1.insert($2,{ans,2});
                symbolTable2.insert($2,ans);
                $$ = new NodeAssn($2, $6);
            }
            }
        }   
     }
     | TDBG Expr
     { 
        std::string s=$2->to_string();
        long long ans=ValueSolver(s);
        Node* nd = new NodeLong(ans);
        $$ = new NodeDebug(nd);
     }
     |TIDENT TEQUAL Expr
     {
        if(symbolTable1.contains($1))
        {
            std::pair<int, int> p =symbolTable1.value($1);
            long long D=FindAns($3->to_string(),p.second);
            if(D==0){
                yyerror("TypeCasting Error\n");
            }
        }
            std::string s=$3->to_string();

            if(checkNotAlpha(s))
            {
                long long ans=solver(s);
                symbolTable.insert($1);
                symbolTable1.insert($1,{ans,2});
                symbolTable1.insert($1,{ans,symbolTable1.value($1).second});
                symbolTable2.update($1,ans);

                Node* nd = new NodeLong(ans);

                $$ = new NodeAssn($1,nd);

            }
        else{
            long long ans = ValueSolver(s);
            symbolTable1.insert($1,{ans,2}); 
            symbolTable2.insert($1,ans); 
            $$=new NodeAssn($1, $3);
        }
        d=0;
     }
     | IF
     | //empty
     {
        $$ = new NodeLong(0);
     }
     |
     FuncDef
     {
        //empty
        $$ = new NodeLong(0);
     }
     ;
 
IF: TIF ExprShort LCurlTxt StmtList RCurlTxt TELSE LCurlTxt StmtList  RCurlTxt
    {   
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeShort(ans);
            $$ = new NodeIfElse(nd,$4,$8);
        }
        else
            $$ = new NodeIfElse($2,$4,$8);
    }
    |TIF ExprShort LCurlTxt StmtList TSCOL RCurlTxt TELSE LCurlTxt StmtList RCurlTxt
    {  
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeShort(ans);
            $$ = new NodeIfElse(nd,$4,$9);
        }
        else
            $$ = new NodeIfElse($2,$4,$9);
    }
    | TIF ExprShort LCurlTxt StmtList RCurlTxt TELSE LCurlTxt StmtList TSCOL RCurlTxt
    {   
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeShort(ans);
            $$ = new NodeIfElse(nd,$4,$8);
        }
        else
            $$ = new NodeIfElse($2,$4,$8);
    }
    |TIF ExprShort LCurlTxt StmtList TSCOL RCurlTxt TELSE LCurlTxt StmtList TSCOL RCurlTxt
    {   
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeShort(ans);
            $$ = new NodeIfElse(nd,$4,$9);
        }
        else
            $$ = new NodeIfElse($2,$4,$9);
    } 
    |TIF ExprInt LCurlTxt StmtList RCurlTxt TELSE LCurlTxt StmtList TSCOL RCurlTxt
    {  
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeInt(ans);
            $$ = new NodeIfElse(nd,$4,$8);
        }
        else
            $$ = new NodeIfElse($2,$4,$8);
    } 
    |
    TIF ExprInt LCurlTxt StmtList RCurlTxt TELSE LCurlTxt StmtList RCurlTxt
    {  
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeInt(ans);
            $$ = new NodeIfElse(nd,$4,$8);
        }
        else
            $$ = new NodeIfElse($2,$4,$8);
    }
    |TIF ExprInt LCurlTxt StmtList TSCOL RCurlTxt TELSE LCurlTxt StmtList RCurlTxt
    {   
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeInt(ans);
            $$ = new NodeIfElse(nd,$4,$9);
        }
        else
            $$ = new NodeIfElse($2,$4,$9);
    }
    
    |TIF ExprInt LCurlTxt StmtList TSCOL RCurlTxt TELSE LCurlTxt StmtList TSCOL RCurlTxt
    {
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeInt(ans);
            $$ = new NodeIfElse(nd,$4,$9);
        }
        else
            $$ = new NodeIfElse($2,$4,$9);
    }
    |
    TIF ExprLong LCurlTxt StmtList RCurlTxt TELSE LCurlTxt StmtList TSCOL RCurlTxt
    {   
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeLong(ans);
            $$ = new NodeIfElse(nd,$4,$8); 
        }
        else
            $$ = new NodeIfElse($2,$4,$8);
    } 
    |
    TIF ExprLong LCurlTxt StmtList RCurlTxt TELSE LCurlTxt StmtList RCurlTxt
    {  
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeLong(ans);
            $$ = new NodeIfElse(nd,$4,$8);
        }
        else
            $$ = new NodeIfElse($2,$4,$8);
    }
    |TIF ExprLong LCurlTxt StmtList TSCOL RCurlTxt TELSE LCurlTxt StmtList RCurlTxt
    {   
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeLong(ans);
            $$ = new NodeIfElse(nd,$4,$9);

            
        }
        else
            $$ = new NodeIfElse($2,$4,$9);
    }
    |TIF ExprLong LCurlTxt StmtList TSCOL RCurlTxt TELSE LCurlTxt StmtList TSCOL RCurlTxt
    {  
        std::string a=$2->to_string();
        if(checkNotAlpha(a))
        {
            long long ans=solver(a);
            Node* nd = new NodeLong(ans);
            $$ = new NodeIfElse(nd,$4,$9);

            
        }
        else
            $$ = new NodeIfElse($2,$4,$9);
    }
    
    ;
 
LCurlTxt: TLCURL { symbolTable2.inc(); }
 
RCurlTxt: TRCURL{ symbolTable2.dec(); }

FuncDef: TFUN TIDENT TLPAREN ParamList TRPAREN TCOLON TINT_TYPE TLCURL StmtList TRCURL
    {
        if(symbolTable2.contains($2)) {
            yyerror("Function Redeclaration!");
        } else {
            symbolTable2.insert($2, 1);
            $$ = new NodeFuncDecl($2,$4,$9);
        }
    }
    ;

ParamList: Stmt                
        { 
            $$ = new NodeStmts(); 
            $$->push_back($1); 
        }
        | ParamList TSCOL Stmt 
        { 
            $$->push_back($3); 
        }
        | ParamList Stmt
        {
            $$->push_back($2);
        }
        | ParamList TSCOL IF
        {
            $$->push_back($3);
        }
        ;

ExprShort:TINT_LIT               
     { 
        if($1[0]!='-'){
            if($1.length()>=6){
                yyerror("Short Range Overflow\n");
            }
            else if($1.length()==5){
                if($1>"32767"){
                   yyerror("Short Range Overflow\n");
                }
            }
        }
        $$ = new NodeShort(stoi($1)); 
        
    }
    | TIDENT
     { 
        if(symbolTable.contains($1))
            $$ = new NodeIdent($1); 
        else
            yyerror("using undeclared variable.\n");
     }
     | ExprShort TPLUS ExprShort
     { 
        $$ = new NodeBinOp(NodeBinOp::PLUS, $1, $3,1);
         std:: string s=$$->to_string();
        if(s=="Short Overflow"){
            yyerror("Short Range Overflow\n");
        }  
    }
     | ExprShort TDASH ExprShort
     { 
        $$ = new NodeBinOp(NodeBinOp::MINUS, $1, $3,1); 
        std:: string s=$$->to_string();
        if(s=="Short Overflow"){
            yyerror("Short Range Overflow\n");
        }  
    }
     | ExprShort TSTAR ExprShort
     { 
        $$ = new NodeBinOp(NodeBinOp::MULT, $1, $3,1); 
        std:: string s=$$->to_string();
        if(s=="Short Overflow"){
            yyerror("Short Range Overflow\n");
        }  
    }
     | ExprShort TSLASH ExprShort
     { 
        $$ = new NodeBinOp(NodeBinOp::DIV, $1, $3,1);
        std:: string s=$$->to_string();
        if(s=="Short Overflow"){
            yyerror("Short Range Overflow\n");
        }  
     }
     | TLPAREN ExprShort TRPAREN { $$ = $2; }
     ;
 

ExprInt:TINT_LIT               
     { 
        if($1[0]!='-'){
            if($1.length()>=11){
                yyerror("Int Range Overflow\n");
            }
            else if($1.length()==10){
                if($1>"2147483647"){
                   yyerror("Int Range Overflow\n");
                }
            }
        }
        $$ = new NodeInt(stoi($1));    
    }
    | TIDENT
     { 
        if(symbolTable.contains($1)) {
            $$ = new NodeIdent($1);
        } else
            yyerror("using undeclared variable.\n");
     }
     | ExprInt TPLUS ExprInt
     { 
        $$ = new NodeBinOp(NodeBinOp::PLUS, $1, $3,2);
        
        std:: string s=$$->to_string();
        if(s=="Integer Overflow"){
            yyerror("Int Range Overflow\n");
        }
     }
     | ExprInt TDASH ExprInt
     { 
        $$ = new NodeBinOp(NodeBinOp::MINUS, $1, $3,2); 
        std:: string s=$$->to_string();
        if(s=="Integer Overflow"){
            yyerror("Int Range Overflow\n");
        }
    }
     | ExprInt TSTAR ExprInt
     { 
        $$ = new NodeBinOp(NodeBinOp::MULT, $1, $3,2);
        std:: string s=$$->to_string();
        if(s=="Integer Overflow"){
            yyerror("Int Range Overflow\n");
        }
    }
     | ExprInt TSLASH ExprInt
     { 
        $$ = new NodeBinOp(NodeBinOp::DIV, $1, $3,2);
     std:: string s=$$->to_string();
        if(s=="Integer Overflow"){
            yyerror("Int Range Overflow\n");
        } 
    }
     | TLPAREN ExprInt TRPAREN { $$ = $2; }
     ;

ExprLong:TINT_LIT               
     { 
        if($1[0]!='-'){
            if($1.length()>=20){
                yyerror("Long Range Overflow\n");
            }
            else if($1.length()==19){
                if($1>"2147483647"){
                   yyerror("Long Range Overflow\n");
                }
            }
        }
        $$ = new NodeLong(stoll($1));     
    }
    | TIDENT
     { 
        if(symbolTable.contains($1)) {
            $$ = new NodeIdent($1); 
        }
        else
            yyerror("using undeclared variable.\n");
     }
     | ExprLong TPLUS ExprLong
     { $$ = new NodeBinOp(NodeBinOp::PLUS, $1, $3,3); }
     | ExprLong TDASH ExprLong
     { $$ = new NodeBinOp(NodeBinOp::MINUS, $1, $3,3); }
     | ExprLong TSTAR ExprLong
     { $$ = new NodeBinOp(NodeBinOp::MULT, $1, $3,3); }
     | ExprLong TSLASH ExprLong
     { $$ = new NodeBinOp(NodeBinOp::DIV, $1, $3,3); }
     | TLPAREN ExprLong TRPAREN { $$ = $2; }
     ;

Expr : TINT_LIT               
     { $$ = new NodeLong(stoll($1)); }
     | TIDENT
     { 
        if(symbolTable2.contains($1)) {
            $$ = new NodeIdent($1);
        } else
            yyerror("using undeclared variable.\n");
     }
     | Expr TPLUS Expr
     { $$ = new NodeBinOp(NodeBinOp::PLUS, $1, $3,0); }
     | Expr TDASH Expr
     { $$ = new NodeBinOp(NodeBinOp::MINUS, $1, $3,0); }
     | Expr TSTAR Expr
     { $$ = new NodeBinOp(NodeBinOp::MULT, $1, $3,0); }
     | Expr TSLASH Expr
     { $$ = new NodeBinOp(NodeBinOp::DIV, $1, $3,0); }
     | TLPAREN Expr TRPAREN { $$ = $2; }
     ;
 
%%
 
int yyerror(std::string msg) {
    std::cerr << "Error! " << msg << std::endl;
    exit(1);
}