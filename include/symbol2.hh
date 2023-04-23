#ifndef SYMBOL2_HH
#define SYMBOL2_HH
#include <bits/stdc++.h>
#include <set>
#include <string>
using namespace std;
#include "ast.hh"

struct SymbolTable2
{
  map<long long, map<string, long long>> scope;
  void dec();
  void inc();
  bool contains(string key);
  void insert(string key, long long value);
  void update(string key, long long value);
  long long get(string key);

  long long curr = 0;
};

#endif