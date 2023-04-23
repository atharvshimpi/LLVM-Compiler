
#include "utils.hh"
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

SymbolTable symbolTable;
SymbolTable1 symbolTable1;
SymbolTable2 symbolTable2;

int checkNotAlpha(std::string s)
{
  std::string t = "";
  for (auto it : s)
  {
    if ((it >= 'a' && it <= 'z') || (it >= 'A' && it <= 'Z'))
      return 0;
  }
  return 1;
}

long long solver(string str)
{
  vector<string> vec;
  for (int i = 0; i < (int)str.length(); i++)
  {
    string temp = "";
    while (i < (int)str.length() && str[i] != ' ')
    {
      temp += str[i];
      i++;
    }
    vec.push_back(temp);
  }

  stack<string> st;
  long long ind = 0;
  while (ind < (int)vec.size())
  {
    if (vec[ind] == ")")
    {
      long long int a, b;
      a = stoll(st.top());
      st.pop();
      b = stoll(st.top());
      st.pop();
      if (st.top() == "+")
      {
        st.pop();
        st.pop();
        st.push(to_string(a + b));
      }
      else if (st.top() == "*")
      {
        st.pop();
        st.pop();
        st.push(to_string(a * b));
      }
      else if (st.top() == "-")
      {
        st.pop();
        st.pop();
        st.push(to_string(b - a));
      }
      else if (st.top() == "/")
      {
        st.pop();
        st.pop();
        st.push(to_string(b / a));
      }
    }
    else
    {
      st.push(vec[ind]);
    }
    ind++;
  }
  return stoll(st.top());
  return 0;
}

long long ValueSolver(string s)
{
  string str = "";
  for (int i = 0; i < (int)s.length(); i++)
  {
    string temp = "";
    while (i < (int)s.length() && ((s[i] >= 'a' && s[i] <= 'z') || (s[i] >= 'A' && s[i] <= 'Z')))
    {
      temp += s[i];
      i++;
    }
    if (temp.length() != 0)
    {

      int p = symbolTable2.get(temp);
      str += to_string(p);
      i--;
      continue;
    }
    str += s[i];
    long long FindAns(string s, int d);
  }
  return solver(str);
}

long long FindAns(string s, int d)
{
  for (int i = 0; i < (int)s.length(); i++)
  {
    string temp = "";
    while (i < (int)s.length() && ((s[i] >= 'a' && s[i] <= 'z') || (s[i] >= 'A' && s[i] <= 'Z')))
    {
      temp += s[i];
      i++;
    }
    if (temp.length() != 0)
    {
      std::pair<int, int> p = symbolTable1.value(temp);
      int k = p.second;
      if (k == d)
        continue;
      if (k > d)
      {
        return 0;
      }
    }
  }
  return 1;
}