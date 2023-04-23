#ifndef SYMBOL_HH
#define SYMBOL_HH
#include <bits/stdc++.h>
#include <set>
#include <string>
using namespace std;
#include "ast.hh"

// Basic symbol table, just keeping track of prior existence and nothing else
struct SymbolTable
{
    set<string> table;

    bool contains(string key);
    void insert(string key);
};

#endif