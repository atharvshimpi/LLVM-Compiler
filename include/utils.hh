#ifndef UTILS_HH
#define UTILS_HH

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

extern SymbolTable symbolTable;
extern SymbolTable1 symbolTable1;
extern SymbolTable2 symbolTable2;

int checkNotAlpha(std::string s);
long long solver(string str);
long long ValueSolver(string s);
long long FindAns(string s, int d);

#endif