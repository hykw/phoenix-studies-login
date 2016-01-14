#!/bin/env python
# -*- coding: utf-8 -*-
from __future__ import (division, print_function, absolute_import, unicode_literals)

import sys
import unicodedata
import zenhan

import jctconv

class BaseBytes(object):
    @staticmethod
    def convert2unicode(strings):
        """ 引数を unicode にする。unicode だったら何もしない """
        if isinstance(strings, str):
            strings = strings.decode('utf-8')

        return strings

    @staticmethod
    def normalize(strings, unistr = 'NFKC'):
        """ 引数を normalize する。"""
        strings = BaseBytes.convert2unicode(strings)
        return unicodedata.normalize(unistr, strings)


class MultiBytes(BaseBytes):

    """
    マルチバイト系の変換メソッド

        c.f.
          http://atasatamatara.hatenablog.jp/entry/2013/04/15/201955
    """

    @staticmethod
    def zenNum2hanNum(strings):
        """
        全角数字を半角数字に変換する
        その他の文字はそのまま
        """
        strings = MultiBytes.convert2unicode(strings)
        return zenhan.z2h(strings, mode=2)


    @staticmethod
    def zenAlphaNum2hanAlphaNum(strings):
        """
        全角英数字を半角英数字に変換する
        """
        strings = MultiBytes.convert2unicode(strings)
        return zenhan.z2h(strings, mode=3)


    @staticmethod
    def hanKana2zenKana(strings):
        """
        半角カナを全角カナに変換する
        その他の文字はそのまま
        """

        strings = MultiBytes.convert2unicode(strings)
        return jctconv.h2z(strings)


    @staticmethod
    def hira2kana(strings):
        """
        全角ひらがなを全角カタカナに変換する
        その他の文字はそのまま

        http://d.hatena.ne.jp/mohayonao/20101213/1292237816
        """
        strings = MultiBytes.convert2unicode(strings)
        return jctconv.hira2kata(strings)


    @staticmethod
    def kana2hira(strings):
        """
        全角カタカナを全角ひらがなに変換する
        その他の文字はそのまま
        """
        strings = MultiBytes.convert2unicode(strings)
        return jctconv.kata2hira(strings)


##################################################

if __name__ == '__main__':
    argv = sys.argv
    argc = len(argv)


    ret = ""
    if (argc == 2):
        ret = MultiBytes.zenAlphaNum2hanAlphaNum(argv[1])

    print(ret)

