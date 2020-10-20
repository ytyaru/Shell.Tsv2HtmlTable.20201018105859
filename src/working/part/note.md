# 入出力

input
```tsv
			ア				イ	ウ	
			A		B				C
			a	b	c	d		e	
あ	A	a	A	B	C	D	E	F	G
		b	H	I	J	K	L	M	N
	B	c	OP		QX	R	STZa		U
		d	V	W		Y			b
い			c	d	e	f	g	h	i
う		e	j	k	l	m	n	o	p
	C		q	r	s	t	u	v	w
```
output
```html
<table>
    <!--行ヘッダ-->
    <tr>
        <th colspan="3" rowspan="3"></th><th colspan="4">ア</th><th rowspan="3">イ</th><th colspan="2">ウ</th>
    </tr>
    <tr>
        <th colspan="2">A</th><th colspan="2">B</th><th></th><th rowspan="2">C</th>
    </tr>
    <tr>
        <th>a</th><th>b</th><th>c</th><th>d</th><th>e</th>
    </tr>
    <!--列ヘッダ+ボディ-->
    <tr>
        <!--列ヘッダ-->
        <th rowspan="4">あ</th><th rowspan="2">A</th><th>a</th>
        <!--ボディ-->
        <td>A</td><td>B</td><td>C</td><td>D</td><td>E</td><td>F</td><td>G</td>
    </tr>
    <tr>
        <th>b</th>
        <td>H</td><td>I</td><td>J</td><td>K</td><td>L</td><td>M</td><td>N</td>
    </tr>
    <tr>
        <th rowspan="2">B</th><th>c</th>
        <td colspan="2">OP</td><td rowspan="2">QX</td><td>R</td><td colspan="2" rowspan="2">STZa</td><td>U</td>
    </tr>
    <tr>
        <th>d</th>
        <td>V</td><td>W</td><td>Y</td><td>b</td>
    </tr>
    <tr>
        <th colspan="3">い</th>
        <td>c</td><td>d</td><td>e</td><td>f</td><td>g</td><td>h</td><td>i</td>
    </tr>
    <tr>
        <th rowspan="2">う</th><th></th><th>e</th>
        <td>j</td><td>k</td><td>l</td><td>m</td><td>n</td><td>o</td><td>p</td>
    </tr>
    <tr>
        <th colspan="2">C</th>
        <td>q</td><td>r</td><td>s</td><td>t</td><td>u</td><td>v</td><td>w</td>
    </tr>
</table>
```

# 手続き

1. tableを4パートに分割する
    1. 最左上端の空白
    2. 行ヘッダ
    3. 列ヘッダ
    4. ボディ


# 行ヘッダ

```tsv
			ア				イ	ウ	
			A		B				C
			a	b	c	d		e	
```

TextLen
```
0,0,0,1,0,0,0,1,1,0
0,0,0,1,0,1,0,0,0,1
0,0,0,1,1,1,1,0,1,0
```
最左上Len
```
0,0,0
0,0,0
0,0,0

colspan=3
rowspan=3
```
ColspanLen
```
1,0,0,0,1,1,0
1,0,1,0,0,0,1
1,1,1,1,0,1,0

NGパターン（rowspan考慮せず）
4,1,2
2,4,1
1,1,1,2,2

OKパターン
4,1,2
2,2,1,1,1
1,1,1,1,1,1,1
```

## rowspan考慮アルゴリズム

　どうやる？　(TSVでは表現不可能？　本質的にツリー構造だから)

* 行ヘッダにrowspanをかけるべきときは？
    * 自セルが空でない
        * 自セルより下行がすべて空である
    * 自セルが空である
        * 自セルより下行がすべて空である
       



