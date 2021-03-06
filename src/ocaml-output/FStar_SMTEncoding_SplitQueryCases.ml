
open Prims

let rec get_next_n_ite : Prims.int  ->  FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term  ->  (FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term)  ->  (Prims.bool * FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) = (fun n t negs f -> if (n <= 0) then begin
(let _173_14 = (f FStar_SMTEncoding_Term.mkTrue)
in (true, _173_14, negs, t))
end else begin
(match (t.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.ITE, (g)::(t)::(e)::_82_7) -> begin
(let _173_19 = (let _173_16 = (let _173_15 = (FStar_SMTEncoding_Term.mkNot g)
in (negs, _173_15))
in (FStar_SMTEncoding_Term.mkAnd _173_16))
in (get_next_n_ite (n - 1) e _173_19 (fun x -> (let _173_18 = (FStar_SMTEncoding_Term.mkITE (g, t, x))
in (f _173_18)))))
end
| FStar_SMTEncoding_Term.FreeV (_82_18) -> begin
(let _173_20 = (f FStar_SMTEncoding_Term.mkTrue)
in (true, _173_20, negs, t))
end
| _82_21 -> begin
(false, FStar_SMTEncoding_Term.mkFalse, FStar_SMTEncoding_Term.mkFalse, FStar_SMTEncoding_Term.mkFalse)
end)
end)


let rec is_ite_all_the_way : Prims.int  ->  FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term Prims.list  ->  (Prims.bool * FStar_SMTEncoding_Term.term Prims.list * FStar_SMTEncoding_Term.term) = (fun n t negs l -> if (n <= 0) then begin
(Prims.raise FStar_Util.Impos)
end else begin
(match (t.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.FreeV (_82_27) -> begin
(let _173_31 = (let _173_30 = (let _173_29 = (FStar_SMTEncoding_Term.mkNot t)
in (negs, _173_29))
in (FStar_SMTEncoding_Term.mkAnd _173_30))
in (true, l, _173_31))
end
| _82_30 -> begin
(

let _82_36 = (get_next_n_ite n t negs (fun x -> x))
in (match (_82_36) with
| (b, t, negs', rest) -> begin
if b then begin
(let _173_34 = (let _173_33 = (FStar_SMTEncoding_Term.mkImp (negs, t))
in (_173_33)::l)
in (is_ite_all_the_way n rest negs' _173_34))
end else begin
(false, [], FStar_SMTEncoding_Term.mkFalse)
end
end))
end)
end)


let rec parse_query_for_split_cases : Prims.int  ->  FStar_SMTEncoding_Term.term  ->  (FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term)  ->  (Prims.bool * ((FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term) * FStar_SMTEncoding_Term.term Prims.list * FStar_SMTEncoding_Term.term)) = (fun n t f -> (match (t.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.Quant (FStar_SMTEncoding_Term.Forall, l, opt, l', t) -> begin
(parse_query_for_split_cases n t (fun x -> (let _173_61 = (FStar_SMTEncoding_Term.mkForall'' (l, opt, l', x))
in (f _173_61))))
end
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Imp, (t1)::(t2)::_82_50) -> begin
(

let r = (match (t2.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.Quant (FStar_SMTEncoding_Term.Forall, _82_59, _82_61, _82_63, _82_65) -> begin
(parse_query_for_split_cases n t2 (fun x -> (let _173_69 = (FStar_SMTEncoding_Term.mkImp (t1, x))
in (f _173_69))))
end
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.ITE, _82_71) -> begin
(

let _82_77 = (is_ite_all_the_way n t2 FStar_SMTEncoding_Term.mkTrue [])
in (match (_82_77) with
| (b, l, negs) -> begin
(b, ((fun x -> (let _173_78 = (FStar_SMTEncoding_Term.mkImp (t1, x))
in (f _173_78))), l, negs))
end))
end
| _82_80 -> begin
(false, ((fun _82_81 -> FStar_SMTEncoding_Term.mkFalse), [], FStar_SMTEncoding_Term.mkFalse))
end)
in r)
end
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.ITE, _82_86) -> begin
(

let _82_92 = (is_ite_all_the_way n t FStar_SMTEncoding_Term.mkTrue [])
in (match (_82_92) with
| (b, l, negs) -> begin
(b, (f, l, negs))
end))
end
| _82_94 -> begin
(false, ((fun _82_95 -> FStar_SMTEncoding_Term.mkFalse), [], FStar_SMTEncoding_Term.mkFalse))
end))


let strip_not : FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term = (fun t -> (match (t.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Not, (hd)::_82_100) -> begin
hd
end
| _82_106 -> begin
t
end))


let rec check_split_cases : (FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term)  ->  FStar_SMTEncoding_Term.term Prims.list  ->  (FStar_SMTEncoding_Term.decl  ->  Prims.unit)  ->  Prims.unit = (fun f l check -> (FStar_List.iter (fun t -> (let _173_117 = (let _173_116 = (let _173_115 = (let _173_114 = (f t)
in (FStar_SMTEncoding_Term.mkNot _173_114))
in (_173_115, None, None))
in FStar_SMTEncoding_Term.Assume (_173_116))
in (check _173_117))) (FStar_List.rev l)))


let check_exhaustiveness : (FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term)  ->  FStar_SMTEncoding_Term.term  ->  (FStar_SMTEncoding_Term.decl  ->  Prims.unit)  ->  Prims.unit = (fun f negs check -> (let _173_138 = (let _173_137 = (let _173_136 = (let _173_135 = (let _173_134 = (FStar_SMTEncoding_Term.mkNot negs)
in (f _173_134))
in (FStar_SMTEncoding_Term.mkNot _173_135))
in (_173_136, None, None))
in FStar_SMTEncoding_Term.Assume (_173_137))
in (check _173_138)))


let can_handle_query : Prims.int  ->  FStar_SMTEncoding_Term.decl  ->  (Prims.bool * ((FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term) * FStar_SMTEncoding_Term.term Prims.list * FStar_SMTEncoding_Term.term)) = (fun n q -> (match (q) with
| FStar_SMTEncoding_Term.Assume (q', _82_118, _82_120) -> begin
(parse_query_for_split_cases n (strip_not q') (fun x -> x))
end
| _82_125 -> begin
(false, ((fun x -> x), [], FStar_SMTEncoding_Term.mkFalse))
end))


let handle_query : ((FStar_SMTEncoding_Term.term  ->  FStar_SMTEncoding_Term.term) * FStar_SMTEncoding_Term.term Prims.list * FStar_SMTEncoding_Term.term)  ->  (FStar_SMTEncoding_Term.decl  ->  Prims.unit)  ->  Prims.unit = (fun _82_130 check -> (match (_82_130) with
| (f, l, negs) -> begin
(

let l = (check_split_cases f l check)
in (check_exhaustiveness f negs check))
end))




