all: a1 a2 t1 t2 restore

a1:
	python vowel_restore.py;
	fstcompile --isymbols=./Syms/A1.syms --keep_isymbols --acceptor < ./Txt/A1.txt > ./FST/A1.fst ;
	fstrmepsilon ./FST/A1.fst ./FST/A1_rmeps.fst;
	fstdeterminize ./FST/A1_rmeps.fst ./FST/A1_det.fst ;
	fstminimize ./FST/A1_det.fst ./FST/A1_min.fst ;
	fstdraw --acceptor < ./FST/A1_min.fst | dot -Tps > ./PS/A1_min.ps;

a2:
	fstcompile --isymbols=./Syms/A1.syms --keep_isymbols --acceptor < ./Txt/space.txt > ./FST/space.fst ;
	fstcompile --isymbols=./Syms/A1.syms --keep_isymbols --acceptor < ./Txt/eps.txt > ./FST/eps.fst ;
	fstcompile --isymbols=./Syms/A1.syms --keep_isymbols --acceptor < ./Txt/newline.txt > ./FST/newline.fst ;
	fstconcat ./FST/space.fst ./FST/A1_min.fst > ./FST/ua.fst ;
	fstclosure ./FST/ua.fst > ./FST/ua_clos.fst ;
	fstconcat ./FST/A1_min.fst ./FST/ua_clos.fst > ./FST/aua.fst ;
	fstunion ./FST/aua.fst ./FST/eps.fst > ./FST/b.fst ;
	fstconcat ./FST/newline.fst ./FST/b.fst > ./FST/nb.fst ;
	fstclosure ./FST/nb.fst > ./FST/nb_clos.fst ;
	fstconcat ./FST/b.fst ./FST/nb_clos.fst > ./FST/A2.fst ;
	fstrmepsilon ./FST/A2.fst ./FST/A2_rmeps.fst;
	fstdeterminize ./FST/A2_rmeps.fst > ./FST/A2_det.fst ;
	fstminimize ./FST/A2_det.fst > ./FST/A2_min.fst ;
	fstdraw --acceptor <  ./FST/A2_min.fst | dot -Tps > ./PS/A2_min.ps;

t1:
	fstcompile --isymbols=./Syms/A1.syms --osymbols=./Syms/A1.syms --keep_isymbols --keep_osymbols < ./Txt/T1.txt  > ./FST/T1.fst;
	fstdraw --isymbols=./Syms/A1.syms --osymbols=./Syms/A1.syms < ./FST/T1.fst | dot -Tps2 > ./PS/T1.ps	;

t2:
	fstarcsort ./FST/A2_min.fst > ./FST/A2_min_sort.fst;
	fstcompose ./FST/T1.fst ./FST/A2_min_sort.fst > ./FST/T2.fst;
	fstdraw --isymbols=./Syms/A1.syms --osymbols=./Syms/A1.syms < ./FST/T2.fst | dot -Tps > ./PS/T2.ps;

restore:
	python text2txtfst.py <input.txt >./FST/input.txtfst;
	fstcompile --isymbols=./Syms/A1.syms --osymbols=./Syms/A1.syms --keep_isymbols --keep_osymbols <./FST/input.txtfst >./FST/input.fst;
	fstcompose ./FST/input.fst ./FST/T2.fst > ./FST/output.fst;
	fstdraw --isymbols=./Syms/A1.syms --osymbols=./Syms/A1.syms < ./FST/output.fst | dot -Tps > ./PS/output.ps;
	fstshortestpath ./FST/output.fst | fsttopsort | fstprint -osymbols=./Syms/A1.syms > ./FST/output.txtfst;
	python outtxtfst2tokens.py < ./FST/output.txtfst > output.txt;

clean:
	rm -rf FST/*.*fst;
	rm -rf PS/*.ps