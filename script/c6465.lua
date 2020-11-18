--Pack Opening Duel
--WIP 5 Packs have been Added 

local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=6465
if self_code then id=self_code end
if not SealedDuel then
	SealedDuel={}
	local function finish_setup()
		--Pre-draw
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_STARTUP)
		e1:SetCountLimit(1)
		e1:SetOperation(SealedDuel.op)
		Duel.RegisterEffect(e1,0)
	end
	--define pack
	--pack[1]=Labyrinth of Nightmare, [2]=Pharaoh's Servant, [3]=Magic Ruler, [4]=Metal Raiders , [5]=Legend of Blue-Eyes
	--[1]=rare, [2]=common, [3]=foil
	pack={}
		pack[1]={}
		pack[1][1]={
91869203,
67371383,
40916023,
7165085,
40133511,
58696829,
32015116,
98456117,
57953380,
21888494,
7565547,
28358902,
85802526,
94377247,
5494820,
90925163,
31829185,
93599951,
57579381,
95286165,
69122763,
94212438,
5616412,
32437102,
8687195,
67105242,
69954399,
58818411,
21598948,
22419772,
64752646,
27132350,
12883044,
31987274,
33550694,
86281779,
12800777,
69140098,
45894482,
13676474,
33737664,
5434080,
46821314,
5600127,
21297224,
94163677,
21770260,
21558682,
83968380,
41855169,
88240808,
90147755,
38480590,
55226821,
27671321,
83746708,
62279055,
71466592,
82432018,
20765952,
29549364,
56948373,
57882509,
86569121,
6343408,
12953226,
19230408,
19827717,
31709826,
70344351,
33950246,
10352095,
87303357,
6733059,
77527210,
52121290,
69832741,
94772232,
31893528,
30170981,
67287533,
13522325,
53530069,
15866454,
21175632,
14644902,
44072894,
3573512,
30606547,
66989694,
68400115,
84080939,
68049471,
86099788,
49064413,
32541773,
76305638,
65475294,
71283180,
18605135,
53582587,
56747793,
95220856,
73216412,
88472456		
		}
		pack[1][2]={}
		pack[1][3]={}
		for _,v in ipairs(pack[1][1]) do table.insert(pack[1][3],v) end
		for _,v in ipairs(pack[1][2]) do table.insert(pack[1][3],v) end
		pack[2]={}
		pack[2][1]={
83994646,
86198326,
48539234,
36868108,
63689843,
36280194,
11761845,
50122883,
57409948,
6104968,
24294108,
78193831,
97077563,
36468556,
1248895,
60682203,
30655537,
67049542,
5388481,
78861134,
24128274,
22959079,
74701381,
30325729,
88733579,
473469,
60082869,
60866277,
96355986,
97687912,
42599677,
3134241,
74923978,
37313786,
423705,
98299011,
84620194,
78658564,
10992251,
61705417,
85742772,
90502999,
73079365,
21015833,
61740673,
54109233,
23615409,
96965364,
16227556,
52675689,
4042268,
77585513,
4266839,
62867251,
49587034,
23171610,
79870141,
59344077,
81210420,
9074847,
75646520,
37580756,
1918087,
22359980,
93108433,
79106360,
31477025,
49251811,
71044499,
17449108,
2130625,
66927994,
2311603,
27911549,
70828912,
43711255,
66719324,
8951260,
67532912,
58621589,
59560625,
98139712,
5265750,
30532390,
35346968,
23471572,
4920010,
87511987,
90908427,
51345461,
32269855,
34694160,
66362965,
3643300,
296499,
43434803,
27125110,
63519819,
78423643,
35316708,
78984772,
21237481,
56387350,
31447217,
12253117		
		}
		pack[2][2]={
83994646,
86198326,
48539234,
36868108,
63689843,
36280194,
11761845,
50122883,
57409948,
6104968,
24294108,
78193831,
97077563,
36468556,
1248895,
60682203,
30655537,
67049542,
5388481,
78861134,
24128274,
22959079,
74701381,
30325729,
88733579,
473469,
60082869,
60866277,
96355986,
97687912,
42599677,
3134241,
74923978,
37313786,
423705,
98299011,
84620194,
78658564,
10992251,
61705417,
85742772,
90502999,
73079365,
21015833,
61740673,
54109233,
23615409,
96965364,
16227556,
52675689,
4042268,
77585513,
4266839,
62867251,
49587034,
23171610,
79870141,
59344077,
81210420,
9074847,
75646520,
37580756,
1918087,
22359980,
93108433,
79106360,
31477025,
49251811,
71044499,
17449108,
2130625,
66927994,
2311603,
27911549,
70828912,
43711255,
66719324,
8951260,
67532912,
58621589,
59560625,
98139712,
5265750,
30532390,
35346968,
23471572,
4920010,
87511987,
90908427,
51345461,
32269855,
34694160,
66362965,
3643300,
296499,
43434803,
27125110,
63519819,
78423643,
35316708,
78984772,
21237481,
56387350,
31447217,
12253117		
		}
		pack[2][3]={
83994646,
86198326,
48539234,
36868108,
63689843,
36280194,
11761845,
50122883,
57409948,
6104968,
24294108,
78193831,
97077563,
36468556,
1248895,
60682203,
30655537,
67049542,
5388481,
78861134,
24128274,
22959079,
74701381,
30325729,
88733579,
473469,
60082869,
60866277,
96355986,
97687912,
42599677,
3134241,
74923978,
37313786,
423705,
98299011,
84620194,
78658564,
10992251,
61705417,
85742772,
90502999,
73079365,
21015833,
61740673,
54109233,
23615409,
96965364,
16227556,
52675689,
4042268,
77585513,
4266839,
62867251,
49587034,
23171610,
79870141,
59344077,
81210420,
9074847,
75646520,
37580756,
1918087,
22359980,
93108433,
79106360,
31477025,
49251811,
71044499,
17449108,
2130625,
66927994,
2311603,
27911549,
70828912,
43711255,
66719324,
8951260,
67532912,
58621589,
59560625,
98139712,
5265750,
30532390,
35346968,
23471572,
4920010,
87511987,
90908427,
51345461,
32269855,
34694160,
66362965,
3643300,
296499,
43434803,
27125110,
63519819,
78423643,
35316708,
78984772,
21237481,
56387350,
31447217,
12253117		
		}
		for _,v in ipairs(pack[2][1]) do table.insert(pack[2][3],v) end
		for _,v in ipairs(pack[2][2]) do table.insert(pack[2][3],v) end
		pack[3]={}
		pack[3][1]={
95174353,
14015067,
40619825,
61528025,
32452818,
41426869,
65169794,
53183600,
21340051,
20228463,
79323590,
81380218,
43417563,
17375316,
91782219,
12470447,
34124316,
35565537,
59784896,
80168720,
44763025,
70681994,
42578427,
11324436,
95051344,
17653779,
18591904,
46534755,
45231177,
96890582,
84834865,
98818516,
1641882,
56594520,
95178994,
97017120,
42703248,
96981563,
16762927,
95744531,
47879985,
80811661,
7089711,
54579801,
46130346,
81863068,
76184692,
38552107,
64047146,
15083728,
30243636,
62397231,
3056267,
90020065,
23289281,
54541900,
19406822,
85705804,
67284908,
94675535,
93108297,
81777047,
56342351,
92731455,
64389297,
93013676,
99597615,
40374923,
13723605,
38369349,
44287299,
34442949,
22046459,
44656491,
55998462,
32539892,
19384334,
57839750,
50913601,
18161786,
83011277,
83464209,
5318639,
50930991,
22567609,
74637266,
33064647,
19523799,
74191942,
21263083,
20624263,
36039163,
4849037,
38142739,
55144522,
77027445,
7892180,
73081602,
65570596,
64631466,
45778932,
70046172,
2964201,
73051941,
23401839,
66516792,
95956346,
3797883,
596051,
45986603,
57617178,
58551308,
18807109,
15023985,
43641473,
42829885,
16430187,
82003859,
65458948,
91842653,
15259703,
77827521,
76806714,
29692206,
56789759,
60806437,
82999629,
70368879,
63162310,
72053645,
91996584		
		}
		pack[3][2]={
95174353,
14015067,
40619825,
61528025,
32452818,
41426869,
65169794,
53183600,
21340051,
20228463,
79323590,
81380218,
43417563,
17375316,
91782219,
12470447,
34124316,
35565537,
59784896,
80168720,
44763025,
70681994,
42578427,
11324436,
95051344,
17653779,
18591904,
46534755,
45231177,
96890582,
84834865,
98818516,
1641882,
56594520,
95178994,
97017120,
42703248,
96981563,
16762927,
95744531,
47879985,
80811661,
7089711,
54579801,
46130346,
81863068,
76184692,
38552107,
64047146,
15083728,
30243636,
62397231,
3056267,
90020065,
23289281,
54541900,
19406822,
85705804,
67284908,
94675535,
93108297,
81777047,
56342351,
92731455,
64389297,
93013676,
99597615,
40374923,
13723605,
38369349,
44287299,
34442949,
22046459,
44656491,
55998462,
32539892,
19384334,
57839750,
50913601,
18161786,
83011277,
83464209,
5318639,
50930991,
22567609,
74637266,
33064647,
19523799,
74191942,
21263083,
20624263,
36039163,
4849037,
38142739,
55144522,
77027445,
7892180,
73081602,
65570596,
64631466,
45778932,
70046172,
2964201,
73051941,
23401839,
66516792,
95956346,
3797883,
596051,
45986603,
57617178,
58551308,
18807109,
15023985,
43641473,
42829885,
16430187,
82003859,
65458948,
91842653,
15259703,
77827521,
76806714,
29692206,
56789759,
60806437,
82999629,
70368879,
63162310,
72053645,
91996584	
		}
		pack[3][3]={
95174353,
14015067,
40619825,
61528025,
32452818,
41426869,
65169794,
53183600,
21340051,
20228463,
79323590,
81380218,
43417563,
17375316,
91782219,
12470447,
34124316,
35565537,
59784896,
80168720,
44763025,
70681994,
42578427,
11324436,
95051344,
17653779,
18591904,
46534755,
45231177,
96890582,
84834865,
98818516,
1641882,
56594520,
95178994,
97017120,
42703248,
96981563,
16762927,
95744531,
47879985,
80811661,
7089711,
54579801,
46130346,
81863068,
76184692,
38552107,
64047146,
15083728,
30243636,
62397231,
3056267,
90020065,
23289281,
54541900,
19406822,
85705804,
67284908,
94675535,
93108297,
81777047,
56342351,
92731455,
64389297,
93013676,
99597615,
40374923,
13723605,
38369349,
44287299,
34442949,
22046459,
44656491,
55998462,
32539892,
19384334,
57839750,
50913601,
18161786,
83011277,
83464209,
5318639,
50930991,
22567609,
74637266,
33064647,
19523799,
74191942,
21263083,
20624263,
36039163,
4849037,
38142739,
55144522,
77027445,
7892180,
73081602,
65570596,
64631466,
45778932,
70046172,
2964201,
73051941,
23401839,
66516792,
95956346,
3797883,
596051,
45986603,
57617178,
58551308,
18807109,
15023985,
43641473,
42829885,
16430187,
82003859,
65458948,
91842653,
15259703,
77827521,
76806714,
29692206,
56789759,
60806437,
82999629,
70368879,
63162310,
72053645,
91996584		
		}
		pack[4]={}
		pack[4][1]={
23771716,
42431843,
93221206,
43230671,
15480588,
20277860,
88819587,
81480461,
18246479,
25655502,
16768387,
11901678,
87564352,
28470714,
70138455,
25880422,
41396436,
81386177,
11384280,
62121,
95727991,
4031928,
40240595,
93889755,
67494157,
89112729,
21417692,
28593363,
73481154,
76446915,
16972957,
55763552,
13215230,
55875323,
90219263,
15237615,
3027001,
41392891,
60862676,
49888191,
25833572,
5818798,
24668830,
8471389,
51828629,
14141448,
58314394,
89272878,
76812113,
12206212,
19613556,
64501875,
98069388,
67629977,
80141480,
2118022,
28546905,
7019529,
14851496,
32809211,
94773007,
9653271,
62340868,
88979991,
69455834,
1184620,
40640057,
99551425,
17358176,
87756343,
87322377,
20394040,
12472242,
10538007,
68658728,
77414722,
31560081,
28933734,
10189126,
21817254,
7489323,
44095762,
55784832,
46657337,
93900406,
56907389,
68516705,
98049915,
7805359,
86088138,
58861941,
21263083,
50152549,
58192742,
549481,
51371017,
10071456,
29155212,
74703140,
5901497,
94905343,
21347810,
20436034,
19066538,
88279736,
68846917,
24611934,
66602787,
25955164,
26202165,
3819470,
30778711,
56830749,
52097679,
2504891,
41420027,
5758500,
8201910,
13599884,
83225447,
98434877,
70781052,
40453765,
98495314,
28725004,
71107816,
41142615,
84926738,
25109950,
51275027,
41462083,
31786629,
71625222,
69572024,
46918794,
78780140,
79759861,
54752875,
2483611,
15150365,
87796900,
78010363,
80741828,
29380133		
		}
		pack[4][2]={
23771716,
42431843,
93221206,
43230671,
15480588,
20277860,
88819587,
81480461,
18246479,
25655502,
16768387,
11901678,
87564352,
28470714,
70138455,
25880422,
41396436,
81386177,
11384280,
62121,
95727991,
4031928,
40240595,
93889755,
67494157,
89112729,
21417692,
28593363,
73481154,
76446915,
16972957,
55763552,
13215230,
55875323,
90219263,
15237615,
3027001,
41392891,
60862676,
49888191,
25833572,
5818798,
24668830,
8471389,
51828629,
14141448,
58314394,
89272878,
76812113,
12206212,
19613556,
64501875,
98069388,
67629977,
80141480,
2118022,
28546905,
7019529,
14851496,
32809211,
94773007,
9653271,
62340868,
88979991,
69455834,
1184620,
40640057,
99551425,
17358176,
87756343,
87322377,
20394040,
12472242,
10538007,
68658728,
77414722,
31560081,
28933734,
10189126,
21817254,
7489323,
44095762,
55784832,
46657337,
93900406,
56907389,
68516705,
98049915,
7805359,
86088138,
58861941,
21263083,
50152549,
58192742,
549481,
51371017,
10071456,
29155212,
74703140,
5901497,
94905343,
21347810,
20436034,
19066538,
88279736,
68846917,
24611934,
66602787,
25955164,
26202165,
3819470,
30778711,
56830749,
52097679,
2504891,
41420027,
5758500,
8201910,
13599884,
83225447,
98434877,
70781052,
40453765,
98495314,
28725004,
71107816,
41142615,
84926738,
25109950,
51275027,
41462083,
31786629,
71625222,
69572024,
46918794,
78780140,
79759861,
54752875,
2483611,
15150365,
87796900,
78010363,
80741828,
29380133
		}
		pack[4][3]={
23771716,
42431843,
93221206,
43230671,
15480588,
20277860,
88819587,
81480461,
18246479,
25655502,
16768387,
11901678,
87564352,
28470714,
70138455,
25880422,
41396436,
81386177,
11384280,
62121,
95727991,
4031928,
40240595,
93889755,
67494157,
89112729,
21417692,
28593363,
73481154,
76446915,
16972957,
55763552,
13215230,
55875323,
90219263,
15237615,
3027001,
41392891,
60862676,
49888191,
25833572,
5818798,
24668830,
8471389,
51828629,
14141448,
58314394,
89272878,
76812113,
12206212,
19613556,
64501875,
98069388,
67629977,
80141480,
2118022,
28546905,
7019529,
14851496,
32809211,
94773007,
9653271,
62340868,
88979991,
69455834,
1184620,
40640057,
99551425,
17358176,
87756343,
87322377,
20394040,
12472242,
10538007,
68658728,
77414722,
31560081,
28933734,
10189126,
21817254,
7489323,
44095762,
55784832,
46657337,
93900406,
56907389,
68516705,
98049915,
7805359,
86088138,
58861941,
21263083,
50152549,
58192742,
549481,
51371017,
10071456,
29155212,
74703140,
5901497,
94905343,
21347810,
20436034,
19066538,
88279736,
68846917,
24611934,
66602787,
25955164,
26202165,
3819470,
30778711,
56830749,
52097679,
2504891,
41420027,
5758500,
8201910,
13599884,
83225447,
98434877,
70781052,
40453765,
98495314,
28725004,
71107816,
41142615,
84926738,
25109950,
51275027,
41462083,
31786629,
71625222,
69572024,
46918794,
78780140,
79759861,
54752875,
2483611,
15150365,
87796900,
78010363,
80741828,
29380133
		}
		for _,v in ipairs(pack[4][1]) do table.insert(pack[4][3],v) end
		for _,v in ipairs(pack[4][2]) do table.insert(pack[4][3],v) end
				pack[5]={}
		pack[5][1]={
111006013,
111006001,
98818516,
98252586,
96851799,
95952802,
94675535,
93553943,
92731455,
90963488,
89091579,
87430998,
85705804,
85639257,
85326399,
85309439,
84686841,
83464209,
82542267,
80770678,
77827521,
77027445,
77007920,
76211194,
76103675,
75376965,
75356564,
74677426,
74677425,
74677424,
74677423,
74677422,
73134082,
73134081,
73051941,
72842870,
72302403,
71407486,
70903634,
70681994,
66889139,
63102017,
61854111,
58528964,
57305373,
56342351,
56283725,
55444629,
55291359,
55144522,
54541900,
53375573,
53293545,
53153481,
51267887,
50913601,
46986420,
46986419,
46986418,
46986417,
46986416,
46986415,
46986414,
46130346,
46009906,
45231178,
45231177,
45042329,
44519536,
44287299,
43500484,
40826495,
39774685,
39111158,
39004808,
38199696,
38142739,
37820550,
37421579,
37313348,
36996508,
36607978,
36121917,
34460851,
33396948,
33178416,
33066139,
33064647,
32452818,
32274490,
29172562,
27847700,
25769732,
24094653,
23424603,
22910685,
22702055,
20060230,
18710707,
17881964,
17535588,
16353197,
15401633,
15052462,
12580477,
11868825,
9293977,
9159938,
9076207,
8124921,
7902349,
2863439,
1641882,
1557499,
1435851,
32864	
		}
		pack[5][2]={
111006013,
111006001,
98818516,
98252586,
96851799,
95952802,
94675535,
93553943,
92731455,
90963488,
89091579,
87430998,
85705804,
85639257,
85326399,
85309439,
84686841,
83464209,
82542267,
80770678,
77827521,
77027445,
77007920,
76211194,
76103675,
75376965,
75356564,
74677426,
74677425,
74677424,
74677423,
74677422,
73134082,
73134081,
73051941,
72842870,
72302403,
71407486,
70903634,
70681994,
66889139,
63102017,
61854111,
58528964,
57305373,
56342351,
56283725,
55444629,
55291359,
55144522,
54541900,
53375573,
53293545,
53153481,
51267887,
50913601,
46986420,
46986419,
46986418,
46986417,
46986416,
46986415,
46986414,
46130346,
46009906,
45231178,
45231177,
45042329,
44519536,
44287299,
43500484,
40826495,
39774685,
39111158,
39004808,
38199696,
38142739,
37820550,
37421579,
37313348,
36996508,
36607978,
36121917,
34460851,
33396948,
33178416,
33066139,
33064647,
32452818,
32274490,
29172562,
27847700,
25769732,
24094653,
23424603,
22910685,
22702055,
20060230,
18710707,
17881964,
17535588,
16353197,
15401633,
15052462,
12580477,
11868825,
9293977,
9159938,
9076207,
8124921,
7902349,
2863439,
1641882,
1557499,
1435851,
32864
		}
		pack[5][3]={
111006013,
111006001,
98818516,
98252586,
96851799,
95952802,
94675535,
93553943,
92731455,
90963488,
89091579,
87430998,
85705804,
85639257,
85326399,
85309439,
84686841,
83464209,
82542267,
80770678,
77827521,
77027445,
77007920,
76211194,
76103675,
75376965,
75356564,
74677426,
74677425,
74677424,
74677423,
74677422,
73134082,
73134081,
73051941,
72842870,
72302403,
71407486,
70903634,
70681994,
66889139,
63102017,
61854111,
58528964,
57305373,
56342351,
56283725,
55444629,
55291359,
55144522,
54541900,
53375573,
53293545,
53153481,
51267887,
50913601,
46986420,
46986419,
46986418,
46986417,
46986416,
46986415,
46986414,
46130346,
46009906,
45231178,
45231177,
45042329,
44519536,
44287299,
43500484,
40826495,
39774685,
39111158,
39004808,
38199696,
38142739,
37820550,
37421579,
37313348,
36996508,
36607978,
36121917,
34460851,
33396948,
33178416,
33066139,
33064647,
32452818,
32274490,
29172562,
27847700,
25769732,
24094653,
23424603,
22910685,
22702055,
20060230,
18710707,
17881964,
17535588,
16353197,
15401633,
15052462,
12580477,
11868825,
9293977,
9159938,
9076207,
8124921,
7902349,
2863439,
1641882,
1557499,
1435851,
32864
		}
		for _,v in ipairs(pack[5][1]) do table.insert(pack[5][3],v) end
		for _,v in ipairs(pack[5][2]) do table.insert(pack[5][3],v) end
		
	local namechange={
		--0 - alternate art, 1 - anime/vg/illegal counterpart
		[78010363]={ [1]={78010363,511003012}; };
		[40737112]={ [1]={40737112,511001039}; };
		[79473793]={ [1]={79473793,511001784}; };
		[10000000]={ [0]={10000000,10000001,10000002}; [1]={10000000,10000001,10000002,110000011,110000011}; };
		[84013237]={ [1]={84013237,511002599}; };
		[69610924]={ [1]={69610924,511002077}; };
		[18144506]={ [0]={18144506,18144507}; };
		[97077563]={ [1]={97077563,511002048}; };
		[83555666]={ [0]={83555666,83555667}; [1]={83555666,83555667,511000824,511000825}; };
		[26905245]={ [1]={26905245,511009214}; };
		[21502796]={ [1]={21502796,511003007}; };
		[19230407]={ [0]={19230407,19230408}; };
		[24874630]={ [1]={24874630,511001596}; };
		[98045062]={ [1]={98045062,511000604}; };
		[37390589]={ [0]={37390589,37390590}; };
		[36261276]={ [1]={36261276,511002539}; };
		[72022087]={ [1]={72022087,511002574}; };
		[78193831]={ [0]={78193831,78193832}; };
		[CARD_CYBER_DRAGON]={ [0]={CARD_CYBER_DRAGON,70095155}; };
		[78700060]={ [1]={78700060,511002514}; };
		[37955049]={ [1]={37955049,511002642}; };
		[51254277]={ [1]={51254277,511001766}; };
		[41098335]={ [1]={41098335,511001396}; };
		[26302522]={ [1]={26302522,511002509}; };
		[65240384]={ [1]={65240384,511001595}; };
		[45894482]={ [1]={45894482,511003006}; };
		[43586926]={ [1]={43586926,511000868}; };
		[30312361]={ [1]={30312361,511001926}; };
		[3657444]={ [1]={3657444,511002464}; };
		[14785765]={ [1]={14785765,511001961}; };
		[15894048]={ [1]={15894048,511003009}; };
		[8483333]={ [1]={8483333,511002425}; };
		[55690251]={ [1]={55690251,511002277}; };
		[45812361]={ [1]={45812361,511001770}; };
		[83764718]={ [1]={83764718,83764719}; };
		[8131171]={ [1]={8131171,511000818}; };
		[26376390]={ [1]={26376390,511002387}; };
		[13893596]={ [1]={13893596,511000243}; };
		[96938777]={ [1]={96938777,511002641}; };
		[65367484]={ [1]={65367484,511002816}; };
		[34016756]={ [1]={34016756,511000474}; };
		[55713623]={ [1]={55713623,511002777}; };
		[12923641]={ [1]={12923641,511003008}; };
		[80921533]={ [1]={80921533,511756002}; };
		[68540058]={ [0]={68540058,68540059}; [1]={68540058,68540059,511006005}; };
		[12117532]={ [1]={12117532,511002814}; };
		[13955608]={ [1]={13955608,511003022,511015121}; };
		[86871614]={ [1]={86871614,511600007}; };
		[79852326]={ [1]={79852326,511000212}; };
		[97168905]={ [1]={97168905,511002911}; };
		[10000010]={ [0]={10000010,10000011}; [1]={10000010,10000011,110000010,110000010}; };
		[10000020]={ [0]={10000020,10000021,10000022}; [1]={10000020,10000021,10000022,110000012,110000012}; };
		[62340868]={ [1]={62340868,511002508}; };
		[2158562]={ [1]={2158562,511001598}; };
		[68722455]={ [1]={68722455,511002263}; };
		[2137678]={ [1]={2137678,511002529}; };
		[39507162]={ [1]={39507162,511019009}; };
		[98649372]={ [1]={98649372,810000029}; };
		[44682448]={ [1]={44682448,344000000}; };
		[74458486]={ [1]={74458486,511002057}; };
		[18271561]={ [1]={18271561,511002541}; };
		[92826944]={ [1]={92826944,511002370}; };
		[10321588]={ [1]={10321588,511018014}; };
		[3370104]={ [1]={3370104,511007022}; };
		[65422840]={ [1]={65422840,511002265}; };
		[36045450]={ [1]={36045450,511600006,511600005}; };
		[1353770]={ [1]={1353770,511002321}; };
		[42502956]={ [1]={42502956,511001622}; };
		[4923662]={ [1]={4923662,511002837}; };
		[25642998]={ [1]={25642998,810000019}; };
		[11411223]={ [1]={11411223,511010010}; };
		[47805931]={ [1]={47805931,511010020}; };
		[80764541]={ [1]={80764541,511001997}; };
		
	}
	function SealedDuel.alternate(code,anime)
		local chk=anime and 1 or 0
		if not namechange[code] or not namechange[code][chk] then return code end
		local num=Duel.GetRandomNumber(1,#namechange[code][chk])
		return namechange[code][chk][num]
	end
	function SealedDuel.op(e,tp,eg,ep,ev,re,r,rp)
		for _,card in ipairs(selfs) do
			Duel.SendtoDeck(card,0,-2,REASON_RULE)
		end
		local counts={}
		counts[0]=Duel.GetPlayersCount(0)
		counts[1]=Duel.GetPlayersCount(1)
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_CARD,0,id)
		--tag variable defining
		local z,o=tp,1-tp
		if not aux.AskEveryone(aux.Stringid(6465,1)) then
			return
		end
		
		--pack selection
		local selectpack={}
		for _,sel in ipairs({Duel.SelectCardsFromCodes(tp,1,5,false,true,5,4,3,2,1)}) do
			selectpack[sel[2]]=true
		end
		
		--pack checking
		if selectpack[3] and not selectpack[1] and not selectpack[2] and not selectpack[5] and not selectpack[4] then
			selectpack[2]=true
		end
		
		--treat as all monster types
		if aux.AskEveryone(aux.Stringid(6465,0)) then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(6465,0)) 
			local getrc=Card.GetRace
			Card.GetRace=function(c)
				if c:IsType(TYPE_MONSTER) then return 0xfffffff end
				return getrc(c)
			end
			local getorigrc=Card.GetOriginalRace
			Card.GetOriginalRace=function(c)
				if c:IsType(TYPE_MONSTER) then return 0xfffffff end
				return getorigrc(c)
			end
			local getprevrc=Card.GetPreviousRaceOnField
			Card.GetPreviousRaceOnField=function(c)
				if (c:GetPreviousTypeOnField()&TYPE_MONSTER)~=0 then return 0xfffffff end
				return getprevrc(c)
			end
			local isrc=Card.IsRace
			Card.IsRace=function(c,r)
				if c:IsType(TYPE_MONSTER) then return true end
				return isrc(c,r)
			end
		end
		--anime counterparts select
		anime=aux.AskEveryone(aux.Stringid(6465,2))
		if anime then
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(6465,2))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(6465,2))
		end
			
		--anime counterparts
		local groups={}
		groups[0]={}
		groups[1]={}
		for i=1,counts[0] do
			groups[0][i]={}
		end
		for i=1,counts[1] do
			groups[1][i]={}
		end
		
		for p=z,o do
			for team=1,counts[p] do
				for i=1,9 do
					local packnum=0
					--random set among selected sets
					repeat
						packnum=Duel.GetRandomNumber(1,5)
					until selectpack[packnum]
					for i=1,5 do
						local rarity
						if i==1 then
							rarity=1
						elseif i<5 then
							rarity=2
						else
							rarity=3
						end
						local code
						if rarity==3 and packnum==3 then
							local tempn=3
							repeat
								tempn=Duel.GetRandomNumber(1,5)
							until tempn~=3 and selectpack[tempn]
							code=pack[tempn][3][Duel.GetRandomNumber(1,#pack[tempn][3])]
						else
							code=pack[packnum][rarity][Duel.GetRandomNumber(1,#pack[packnum][rarity])]
						end
						local finalcode=SealedDuel.alternate(code,anime)
						table.insert(groups[p][team],finalcode)
					end
				end
			end
		end
		
		for p=z,o do
			for team=1,counts[p] do
				Duel.SendtoDeck(Duel.GetFieldGroup(p,0xff,0),nil,-2,REASON_RULE)
				for idx,code in ipairs(groups[p][team]) do
					Debug.AddCard(code,p,p,LOCATION_DECK,1,POS_FACEDOWN_DEFENSE)
				end
				Debug.ReloadFieldEnd()
				Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(6465,3))
				local fg=Duel.GetFieldGroup(p,0xff,0)
				local exclude=fg:Select(p,0,#fg-20,nil)
				if exclude then
					Duel.SendtoDeck(exclude,nil,-2,REASON_RULE)
				end
				Duel.ShuffleDeck(p)
				Duel.ShuffleExtra(p)
				local dtpg=Duel.GetDecktopGroup(p,Duel.GetStartingHand(p))
				Duel.ConfirmCards(p,dtpg)
				if Duel.SelectYesNo(p,aux.Stringid(id,3)) then
					Duel.MoveToDeckBottom(dtpg)
				end
				if counts[p]~=1 then
					Duel.TagSwap(p)
				end
			end
		end
	end
	finish_setup()
end
if not Duel.GetStartingHand then
	Duel.GetStartingHand=function() return 5 end
end
