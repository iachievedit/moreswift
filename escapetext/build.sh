#!/bin/sh

# escapetext C application
clang -D__TEST__ -o escapetext escapetext.c -lcurl

# escapeswift Swift application
gcc -c escapetext.c
swiftc -c escapeswift.swift -import-objc-header escapetext.h 
swiftc escapeswift.o escapetext.o -o escapeswift -lcurl
