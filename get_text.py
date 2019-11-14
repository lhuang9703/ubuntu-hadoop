#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 lhuang <lhuang9703@gmail.com>
#
# Distributed under terms of the MIT license.

"""

"""

num = 1000

with open('/Users/lhuang/Downloads/collection.tsv', 'r') as f:
    count = 0
    for line in f:
        if count == num:
            break
        line_split = line.strip().split('\t')
        if len(line_split) == 2:
            wf = open('corpus/' + line_split[0] + '.txt', 'w')
            wf.write(line_split[1] + '\n')
            wf.close()
        count += 1

