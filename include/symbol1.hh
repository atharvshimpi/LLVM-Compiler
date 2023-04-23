#ifndef SYMBOL1_HH
#define SYMBOL1_HH
#include <bits/stdc++.h>
#include <set>
#include <string>
using namespace std;
#include "ast.hh"

// Basic symbol table, just keeping track of prior existence and nothing else

struct SymbolTable1
{
    map<string, pair<long long, long long>> table; // value,type

    bool contains(string key);
    void insert(string key, pair<long long, long long> val);
    pair<long long, long long> value(string key);
};



#endif