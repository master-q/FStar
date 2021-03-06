
open Prims

let infix_prim_ops : (FStar_Absyn_Syntax.lident * Prims.string) Prims.list = ((FStar_Absyn_Const.op_Addition, "+"))::((FStar_Absyn_Const.op_Subtraction, "-"))::((FStar_Absyn_Const.op_Multiply, "*"))::((FStar_Absyn_Const.op_Division, "/"))::((FStar_Absyn_Const.op_Eq, "="))::((FStar_Absyn_Const.op_ColonEq, ":="))::((FStar_Absyn_Const.op_notEq, "<>"))::((FStar_Absyn_Const.op_And, "&&"))::((FStar_Absyn_Const.op_Or, "||"))::((FStar_Absyn_Const.op_LTE, "<="))::((FStar_Absyn_Const.op_GTE, ">="))::((FStar_Absyn_Const.op_LT, "<"))::((FStar_Absyn_Const.op_GT, ">"))::((FStar_Absyn_Const.op_Modulus, "mod"))::[]


let unary_prim_ops : (FStar_Absyn_Syntax.lident * Prims.string) Prims.list = ((FStar_Absyn_Const.op_Negation, "not"))::((FStar_Absyn_Const.op_Minus, "-"))::[]


let infix_type_ops : (FStar_Absyn_Syntax.lident * Prims.string) Prims.list = ((FStar_Absyn_Const.and_lid, "/\\"))::((FStar_Absyn_Const.or_lid, "\\/"))::((FStar_Absyn_Const.imp_lid, "==>"))::((FStar_Absyn_Const.iff_lid, "<==>"))::((FStar_Absyn_Const.precedes_lid, "<<"))::((FStar_Absyn_Const.eq2_lid, "=="))::((FStar_Absyn_Const.eqT_lid, "=="))::[]


let unary_type_ops : (FStar_Absyn_Syntax.lident * Prims.string) Prims.list = ((FStar_Absyn_Const.not_lid, "~"))::[]


let is_prim_op = (fun ps f -> (match (f.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Exp_fvar (fv, _32_22) -> begin
(FStar_All.pipe_right ps (FStar_Util.for_some (FStar_Ident.lid_equals fv.FStar_Absyn_Syntax.v)))
end
| _32_26 -> begin
false
end))


let is_type_op = (fun ps t -> (match (t.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_const (ftv) -> begin
(FStar_All.pipe_right ps (FStar_Util.for_some (FStar_Ident.lid_equals ftv.FStar_Absyn_Syntax.v)))
end
| _32_32 -> begin
false
end))


let get_lid = (fun f -> (match (f.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Exp_fvar (fv, _32_36) -> begin
fv.FStar_Absyn_Syntax.v
end
| _32_40 -> begin
(FStar_All.failwith "get_lid")
end))


let get_type_lid = (fun t -> (match (t.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_const (ftv) -> begin
ftv.FStar_Absyn_Syntax.v
end
| _32_45 -> begin
(FStar_All.failwith "get_type_lid")
end))


let is_infix_prim_op : FStar_Absyn_Syntax.exp  ->  Prims.bool = (fun e -> (is_prim_op (Prims.fst (FStar_List.split infix_prim_ops)) e))


let is_unary_prim_op : FStar_Absyn_Syntax.exp  ->  Prims.bool = (fun e -> (is_prim_op (Prims.fst (FStar_List.split unary_prim_ops)) e))


let is_infix_type_op : FStar_Absyn_Syntax.typ  ->  Prims.bool = (fun t -> (is_type_op (Prims.fst (FStar_List.split infix_type_ops)) t))


let is_unary_type_op : FStar_Absyn_Syntax.typ  ->  Prims.bool = (fun t -> (is_type_op (Prims.fst (FStar_List.split unary_type_ops)) t))


let quants : (FStar_Absyn_Syntax.lident * Prims.string) Prims.list = ((FStar_Absyn_Const.forall_lid, "forall"))::((FStar_Absyn_Const.exists_lid, "exists"))::((FStar_Absyn_Const.allTyp_lid, "forall"))::((FStar_Absyn_Const.exTyp_lid, "exists"))::[]


let is_b2t : FStar_Absyn_Syntax.typ  ->  Prims.bool = (fun t -> (is_type_op ((FStar_Absyn_Const.b2t_lid)::[]) t))


let is_quant : FStar_Absyn_Syntax.typ  ->  Prims.bool = (fun t -> (is_type_op (Prims.fst (FStar_List.split quants)) t))


let is_ite : FStar_Absyn_Syntax.typ  ->  Prims.bool = (fun t -> (is_type_op ((FStar_Absyn_Const.ite_lid)::[]) t))


let is_lex_cons : FStar_Absyn_Syntax.exp  ->  Prims.bool = (fun f -> (is_prim_op ((FStar_Absyn_Const.lexcons_lid)::[]) f))


let is_lex_top : FStar_Absyn_Syntax.exp  ->  Prims.bool = (fun f -> (is_prim_op ((FStar_Absyn_Const.lextop_lid)::[]) f))


let is_inr = (fun _32_1 -> (match (_32_1) with
| FStar_Util.Inl (_32_57) -> begin
false
end
| FStar_Util.Inr (_32_60) -> begin
true
end))


let rec reconstruct_lex : FStar_Absyn_Syntax.exp  ->  (FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax Prims.list Prims.option = (fun e -> (match ((let _123_28 = (FStar_Absyn_Util.compress_exp e)
in _123_28.FStar_Absyn_Syntax.n)) with
| FStar_Absyn_Syntax.Exp_app (f, args) -> begin
(

let args = (FStar_List.filter (fun a -> (match (a) with
| ((FStar_Util.Inl (_), _)) | ((FStar_Util.Inr (_), Some (FStar_Absyn_Syntax.Implicit (_)))) -> begin
false
end
| _32_83 -> begin
true
end)) args)
in (

let exps = (FStar_List.map (fun _32_2 -> (match (_32_2) with
| (FStar_Util.Inl (_32_87), _32_90) -> begin
(FStar_All.failwith "impossible")
end
| (FStar_Util.Inr (x), _32_95) -> begin
x
end)) args)
in if ((is_lex_cons f) && ((FStar_List.length exps) = 2)) then begin
(match ((let _123_31 = (FStar_List.nth exps 1)
in (reconstruct_lex _123_31))) with
| Some (xs) -> begin
(let _123_33 = (let _123_32 = (FStar_List.nth exps 0)
in (_123_32)::xs)
in Some (_123_33))
end
| None -> begin
None
end)
end else begin
None
end))
end
| _32_102 -> begin
if (is_lex_top e) then begin
Some ([])
end else begin
None
end
end))


let rec find = (fun f l -> (match (l) with
| [] -> begin
(FStar_All.failwith "blah")
end
| (hd)::tl -> begin
if (f hd) then begin
hd
end else begin
(find f tl)
end
end))


let find_lid : FStar_Ident.lident  ->  (FStar_Ident.lident * Prims.string) Prims.list  ->  Prims.string = (fun x xs -> (let _123_47 = (find (fun p -> (FStar_Ident.lid_equals x (Prims.fst p))) xs)
in (Prims.snd _123_47)))


let infix_prim_op_to_string = (fun e -> (let _123_49 = (get_lid e)
in (find_lid _123_49 infix_prim_ops)))


let unary_prim_op_to_string = (fun e -> (let _123_51 = (get_lid e)
in (find_lid _123_51 unary_prim_ops)))


let infix_type_op_to_string = (fun t -> (let _123_53 = (get_type_lid t)
in (find_lid _123_53 infix_type_ops)))


let unary_type_op_to_string = (fun t -> (let _123_55 = (get_type_lid t)
in (find_lid _123_55 unary_type_ops)))


let quant_to_string = (fun t -> (let _123_57 = (get_type_lid t)
in (find_lid _123_57 quants)))


let rec sli : FStar_Ident.lident  ->  Prims.string = (fun l -> if (FStar_Options.print_real_names ()) then begin
l.FStar_Ident.str
end else begin
l.FStar_Ident.ident.FStar_Ident.idText
end)


let strBvd = (fun bvd -> if (FStar_Options.print_real_names ()) then begin
(Prims.strcat bvd.FStar_Absyn_Syntax.ppname.FStar_Ident.idText bvd.FStar_Absyn_Syntax.realname.FStar_Ident.idText)
end else begin
if ((FStar_Options.hide_genident_nums ()) && (FStar_Util.starts_with bvd.FStar_Absyn_Syntax.ppname.FStar_Ident.idText "_")) then begin
try
(match (()) with
| () -> begin
(

let _32_127 = (let _123_62 = (FStar_Util.substring_from bvd.FStar_Absyn_Syntax.ppname.FStar_Ident.idText 1)
in (FStar_Util.int_of_string _123_62))
in "_?")
end)
with
| _32_124 -> begin
bvd.FStar_Absyn_Syntax.ppname.FStar_Ident.idText
end
end else begin
bvd.FStar_Absyn_Syntax.ppname.FStar_Ident.idText
end
end)


let filter_imp = (fun a -> (FStar_All.pipe_right a (FStar_List.filter (fun _32_3 -> (match (_32_3) with
| (_32_132, Some (FStar_Absyn_Syntax.Implicit (_32_134))) -> begin
false
end
| _32_139 -> begin
true
end)))))


let const_to_string : FStar_Const.sconst  ->  Prims.string = (fun x -> (match (x) with
| FStar_Const.Const_effect -> begin
"eff"
end
| FStar_Const.Const_unit -> begin
"()"
end
| FStar_Const.Const_bool (b) -> begin
if b then begin
"true"
end else begin
"false"
end
end
| FStar_Const.Const_float (x) -> begin
(FStar_Util.string_of_float x)
end
| FStar_Const.Const_char (x) -> begin
(Prims.strcat (Prims.strcat "\'" (FStar_Util.string_of_char x)) "\'")
end
| FStar_Const.Const_string (bytes, _32_151) -> begin
(FStar_Util.format1 "\"%s\"" (FStar_Util.string_of_bytes bytes))
end
| FStar_Const.Const_bytearray (_32_155) -> begin
"<bytearray>"
end
| FStar_Const.Const_int (x, _32_159) -> begin
x
end
| FStar_Const.Const_range (r) -> begin
(FStar_Range.string_of_range r)
end))


let rec tag_of_typ : (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax  ->  Prims.string = (fun t -> (match (t.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_btvar (_32_166) -> begin
"Typ_btvar"
end
| FStar_Absyn_Syntax.Typ_const (v) -> begin
(Prims.strcat "Typ_const " v.FStar_Absyn_Syntax.v.FStar_Ident.str)
end
| FStar_Absyn_Syntax.Typ_fun (_32_171) -> begin
"Typ_fun"
end
| FStar_Absyn_Syntax.Typ_refine (_32_174) -> begin
"Typ_refine"
end
| FStar_Absyn_Syntax.Typ_app (head, args) -> begin
(let _123_103 = (tag_of_typ head)
in (let _123_102 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length args))
in (FStar_Util.format2 "Typ_app(%s, [%s args])" _123_103 _123_102)))
end
| FStar_Absyn_Syntax.Typ_lam (_32_181) -> begin
"Typ_lam"
end
| FStar_Absyn_Syntax.Typ_ascribed (_32_184) -> begin
"Typ_ascribed"
end
| FStar_Absyn_Syntax.Typ_meta (FStar_Absyn_Syntax.Meta_pattern (_32_187)) -> begin
"Typ_meta_pattern"
end
| FStar_Absyn_Syntax.Typ_meta (FStar_Absyn_Syntax.Meta_named (_32_191)) -> begin
"Typ_meta_named"
end
| FStar_Absyn_Syntax.Typ_meta (FStar_Absyn_Syntax.Meta_labeled (_32_195)) -> begin
"Typ_meta_labeled"
end
| FStar_Absyn_Syntax.Typ_meta (FStar_Absyn_Syntax.Meta_refresh_label (_32_199)) -> begin
"Typ_meta_refresh_label"
end
| FStar_Absyn_Syntax.Typ_meta (FStar_Absyn_Syntax.Meta_slack_formula (_32_203)) -> begin
"Typ_meta_slack_formula"
end
| FStar_Absyn_Syntax.Typ_uvar (_32_207) -> begin
"Typ_uvar"
end
| FStar_Absyn_Syntax.Typ_delayed (_32_210) -> begin
"Typ_delayed"
end
| FStar_Absyn_Syntax.Typ_unknown -> begin
"Typ_unknown"
end))
and tag_of_exp = (fun e -> (match (e.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Exp_bvar (_32_215) -> begin
"Exp_bvar"
end
| FStar_Absyn_Syntax.Exp_fvar (_32_218) -> begin
"Exp_fvar"
end
| FStar_Absyn_Syntax.Exp_constant (_32_221) -> begin
"Exp_constant"
end
| FStar_Absyn_Syntax.Exp_abs (_32_224) -> begin
"Exp_abs"
end
| FStar_Absyn_Syntax.Exp_app (_32_227) -> begin
"Exp_app"
end
| FStar_Absyn_Syntax.Exp_match (_32_230) -> begin
"Exp_match"
end
| FStar_Absyn_Syntax.Exp_ascribed (_32_233) -> begin
"Exp_ascribed"
end
| FStar_Absyn_Syntax.Exp_let (_32_236) -> begin
"Exp_let"
end
| FStar_Absyn_Syntax.Exp_uvar (_32_239) -> begin
"Exp_uvar"
end
| FStar_Absyn_Syntax.Exp_delayed (_32_242) -> begin
"Exp_delayed"
end
| FStar_Absyn_Syntax.Exp_meta (FStar_Absyn_Syntax.Meta_desugared (_32_245, m)) -> begin
(let _123_107 = (meta_e_to_string m)
in (Prims.strcat "Exp_meta_desugared " _123_107))
end))
and meta_e_to_string : FStar_Absyn_Syntax.meta_source_info  ->  Prims.string = (fun _32_4 -> (match (_32_4) with
| FStar_Absyn_Syntax.Data_app -> begin
"Data_app"
end
| FStar_Absyn_Syntax.Sequence -> begin
"Sequence"
end
| FStar_Absyn_Syntax.Primop -> begin
"Primop"
end
| FStar_Absyn_Syntax.Masked_effect -> begin
"Masked_effect"
end
| FStar_Absyn_Syntax.Meta_smt_pat -> begin
"Meta_smt_pat"
end))
and typ_to_string : (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax  ->  Prims.string = (fun x -> (

let x = (FStar_Absyn_Util.compress_typ x)
in (match (x.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_delayed (_32_259) -> begin
(FStar_All.failwith "impossible")
end
| FStar_Absyn_Syntax.Typ_meta (FStar_Absyn_Syntax.Meta_named (_32_262, l)) -> begin
(sli l)
end
| FStar_Absyn_Syntax.Typ_meta (meta) -> begin
(let _123_113 = (FStar_All.pipe_right meta meta_to_string)
in (FStar_Util.format1 "(Meta %s)" _123_113))
end
| FStar_Absyn_Syntax.Typ_btvar (btv) -> begin
(strBvd btv.FStar_Absyn_Syntax.v)
end
| FStar_Absyn_Syntax.Typ_const (v) -> begin
(sli v.FStar_Absyn_Syntax.v)
end
| FStar_Absyn_Syntax.Typ_fun (binders, c) -> begin
(let _123_115 = (binders_to_string " -> " binders)
in (let _123_114 = (comp_typ_to_string c)
in (FStar_Util.format2 "(%s -> %s)" _123_115 _123_114)))
end
| FStar_Absyn_Syntax.Typ_refine (xt, f) -> begin
(let _123_118 = (strBvd xt.FStar_Absyn_Syntax.v)
in (let _123_117 = (FStar_All.pipe_right xt.FStar_Absyn_Syntax.sort typ_to_string)
in (let _123_116 = (FStar_All.pipe_right f formula_to_string)
in (FStar_Util.format3 "%s:%s{%s}" _123_118 _123_117 _123_116))))
end
| FStar_Absyn_Syntax.Typ_app (_32_282, []) -> begin
(FStar_All.failwith "Empty args!")
end
| FStar_Absyn_Syntax.Typ_app (t, args) -> begin
(

let q_to_string = (fun k a -> (match ((Prims.fst a)) with
| FStar_Util.Inl (t) -> begin
(

let t = (FStar_Absyn_Util.compress_typ t)
in (match (t.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_lam ((b)::[], t) -> begin
(k (b, t))
end
| _32_302 -> begin
(let _123_129 = (tag_of_typ t)
in (let _123_128 = (typ_to_string t)
in (FStar_Util.format2 "<Expected a type-lambda! got %s>%s" _123_129 _123_128)))
end))
end
| FStar_Util.Inr (e) -> begin
(let _123_130 = (exp_to_string e)
in (FStar_Util.format1 "(<Expected a type!>%s)" _123_130))
end))
in (

let qbinder_to_string = (q_to_string (fun x -> (binder_to_string (Prims.fst x))))
in (

let qbody_to_string = (q_to_string (fun x -> (typ_to_string (Prims.snd x))))
in (

let args' = if ((FStar_Options.print_implicits ()) && (not ((is_quant t)))) then begin
args
end else begin
(filter_imp args)
end
in if ((is_ite t) && ((FStar_List.length args) = 3)) then begin
(let _123_140 = (let _123_135 = (FStar_List.nth args 0)
in (arg_to_string _123_135))
in (let _123_139 = (let _123_136 = (FStar_List.nth args 1)
in (arg_to_string _123_136))
in (let _123_138 = (let _123_137 = (FStar_List.nth args 2)
in (arg_to_string _123_137))
in (FStar_Util.format3 "if %s then %s else %s" _123_140 _123_139 _123_138))))
end else begin
if ((is_b2t t) && ((FStar_List.length args) = 1)) then begin
(let _123_141 = (FStar_List.nth args 0)
in (FStar_All.pipe_right _123_141 arg_to_string))
end else begin
if ((is_quant t) && ((FStar_List.length args) <= 2)) then begin
(let _123_146 = (quant_to_string t)
in (let _123_145 = (let _123_142 = (FStar_List.nth args' 0)
in (qbinder_to_string _123_142))
in (let _123_144 = (let _123_143 = (FStar_List.nth args' 0)
in (qbody_to_string _123_143))
in (FStar_Util.format3 "(%s (%s). %s)" _123_146 _123_145 _123_144))))
end else begin
if ((is_infix_type_op t) && ((FStar_List.length args') = 2)) then begin
(let _123_151 = (let _123_147 = (FStar_List.nth args' 0)
in (FStar_All.pipe_right _123_147 arg_to_string))
in (let _123_150 = (FStar_All.pipe_right t infix_type_op_to_string)
in (let _123_149 = (let _123_148 = (FStar_List.nth args' 1)
in (FStar_All.pipe_right _123_148 arg_to_string))
in (FStar_Util.format3 "(%s %s %s)" _123_151 _123_150 _123_149))))
end else begin
if ((is_unary_type_op t) && ((FStar_List.length args') = 1)) then begin
(let _123_154 = (FStar_All.pipe_right t unary_type_op_to_string)
in (let _123_153 = (let _123_152 = (FStar_List.nth args' 0)
in (FStar_All.pipe_right _123_152 arg_to_string))
in (FStar_Util.format2 "(%s %s)" _123_154 _123_153)))
end else begin
(let _123_156 = (FStar_All.pipe_right t typ_to_string)
in (let _123_155 = (FStar_All.pipe_right args args_to_string)
in (FStar_Util.format2 "(%s %s)" _123_156 _123_155)))
end
end
end
end
end))))
end
| FStar_Absyn_Syntax.Typ_lam (binders, t2) -> begin
(let _123_158 = (binders_to_string " " binders)
in (let _123_157 = (FStar_All.pipe_right t2 typ_to_string)
in (FStar_Util.format2 "(fun %s -> %s)" _123_158 _123_157)))
end
| FStar_Absyn_Syntax.Typ_ascribed (t, k) -> begin
if (FStar_Options.print_real_names ()) then begin
(let _123_160 = (typ_to_string t)
in (let _123_159 = (kind_to_string k)
in (FStar_Util.format2 "(%s <: %s)" _123_160 _123_159)))
end else begin
(FStar_All.pipe_right t typ_to_string)
end
end
| FStar_Absyn_Syntax.Typ_unknown -> begin
"<UNKNOWN>"
end
| FStar_Absyn_Syntax.Typ_uvar (uv, k) -> begin
(match ((FStar_Absyn_Visit.compress_typ_aux false x)) with
| {FStar_Absyn_Syntax.n = FStar_Absyn_Syntax.Typ_uvar (_32_332); FStar_Absyn_Syntax.tk = _32_330; FStar_Absyn_Syntax.pos = _32_328; FStar_Absyn_Syntax.fvs = _32_326; FStar_Absyn_Syntax.uvs = _32_324} -> begin
(uvar_t_to_string (uv, k))
end
| t -> begin
(FStar_All.pipe_right t typ_to_string)
end)
end)))
and uvar_t_to_string : (FStar_Absyn_Syntax.uvar_t * FStar_Absyn_Syntax.knd)  ->  Prims.string = (fun _32_338 -> (match (_32_338) with
| (uv, k) -> begin
if (false && (FStar_Options.print_real_names ())) then begin
(let _123_164 = if (FStar_Options.hide_uvar_nums ()) then begin
"?"
end else begin
(let _123_162 = (FStar_Unionfind.uvar_id uv)
in (FStar_Util.string_of_int _123_162))
end
in (let _123_163 = (kind_to_string k)
in (FStar_Util.format2 "(U%s : %s)" _123_164 _123_163)))
end else begin
(let _123_166 = if (FStar_Options.hide_uvar_nums ()) then begin
"?"
end else begin
(let _123_165 = (FStar_Unionfind.uvar_id uv)
in (FStar_Util.string_of_int _123_165))
end
in (FStar_Util.format1 "U%s" _123_166))
end
end))
and imp_to_string : Prims.string  ->  FStar_Absyn_Syntax.arg_qualifier Prims.option  ->  Prims.string = (fun s _32_5 -> (match (_32_5) with
| Some (FStar_Absyn_Syntax.Implicit (_32_342)) -> begin
(Prims.strcat "#" s)
end
| Some (FStar_Absyn_Syntax.Equality) -> begin
(Prims.strcat "=" s)
end
| _32_348 -> begin
s
end))
and binder_to_string' : Prims.bool  ->  ((((FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax FStar_Absyn_Syntax.bvdef, (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.withinfo_t, ((FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax FStar_Absyn_Syntax.bvdef, (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.withinfo_t) FStar_Util.either * FStar_Absyn_Syntax.arg_qualifier Prims.option)  ->  Prims.string = (fun is_arrow b -> (match (b) with
| (FStar_Util.Inl (a), imp) -> begin
if ((FStar_Absyn_Syntax.is_null_binder b) || ((let _123_171 = (FStar_Options.print_real_names ())
in (FStar_All.pipe_right _123_171 Prims.op_Negation)) && (FStar_Absyn_Syntax.is_null_pp a.FStar_Absyn_Syntax.v))) then begin
(kind_to_string a.FStar_Absyn_Syntax.sort)
end else begin
if ((not (is_arrow)) && (not ((FStar_Options.print_implicits ())))) then begin
(let _123_172 = (strBvd a.FStar_Absyn_Syntax.v)
in (imp_to_string _123_172 imp))
end else begin
(let _123_176 = (let _123_175 = (let _123_173 = (strBvd a.FStar_Absyn_Syntax.v)
in (Prims.strcat _123_173 ":"))
in (let _123_174 = (kind_to_string a.FStar_Absyn_Syntax.sort)
in (Prims.strcat _123_175 _123_174)))
in (imp_to_string _123_176 imp))
end
end
end
| (FStar_Util.Inr (x), imp) -> begin
if ((FStar_Absyn_Syntax.is_null_binder b) || ((let _123_177 = (FStar_Options.print_real_names ())
in (FStar_All.pipe_right _123_177 Prims.op_Negation)) && (FStar_Absyn_Syntax.is_null_pp x.FStar_Absyn_Syntax.v))) then begin
(typ_to_string x.FStar_Absyn_Syntax.sort)
end else begin
if ((not (is_arrow)) && (not ((FStar_Options.print_implicits ())))) then begin
(let _123_178 = (strBvd x.FStar_Absyn_Syntax.v)
in (imp_to_string _123_178 imp))
end else begin
(let _123_182 = (let _123_181 = (let _123_179 = (strBvd x.FStar_Absyn_Syntax.v)
in (Prims.strcat _123_179 ":"))
in (let _123_180 = (typ_to_string x.FStar_Absyn_Syntax.sort)
in (Prims.strcat _123_181 _123_180)))
in (imp_to_string _123_182 imp))
end
end
end))
and binder_to_string : ((((FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax FStar_Absyn_Syntax.bvdef, (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.withinfo_t, ((FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax FStar_Absyn_Syntax.bvdef, (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.withinfo_t) FStar_Util.either * FStar_Absyn_Syntax.arg_qualifier Prims.option)  ->  Prims.string = (fun b -> (binder_to_string' false b))
and arrow_binder_to_string : ((((FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax FStar_Absyn_Syntax.bvdef, (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.withinfo_t, ((FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax FStar_Absyn_Syntax.bvdef, (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.withinfo_t) FStar_Util.either * FStar_Absyn_Syntax.arg_qualifier Prims.option)  ->  Prims.string = (fun b -> (binder_to_string' true b))
and binders_to_string : Prims.string  ->  FStar_Absyn_Syntax.binders  ->  Prims.string = (fun sep bs -> (

let bs = if (FStar_Options.print_implicits ()) then begin
bs
end else begin
(filter_imp bs)
end
in if (sep = " -> ") then begin
(let _123_187 = (FStar_All.pipe_right bs (FStar_List.map arrow_binder_to_string))
in (FStar_All.pipe_right _123_187 (FStar_String.concat sep)))
end else begin
(let _123_188 = (FStar_All.pipe_right bs (FStar_List.map binder_to_string))
in (FStar_All.pipe_right _123_188 (FStar_String.concat sep)))
end))
and arg_to_string : (((FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax, (FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Util.either * FStar_Absyn_Syntax.arg_qualifier Prims.option)  ->  Prims.string = (fun _32_6 -> (match (_32_6) with
| (FStar_Util.Inl (a), imp) -> begin
(let _123_190 = (typ_to_string a)
in (imp_to_string _123_190 imp))
end
| (FStar_Util.Inr (x), imp) -> begin
(let _123_191 = (exp_to_string x)
in (imp_to_string _123_191 imp))
end))
and args_to_string : FStar_Absyn_Syntax.args  ->  Prims.string = (fun args -> (

let args = if (FStar_Options.print_implicits ()) then begin
args
end else begin
(filter_imp args)
end
in (let _123_193 = (FStar_All.pipe_right args (FStar_List.map arg_to_string))
in (FStar_All.pipe_right _123_193 (FStar_String.concat " ")))))
and lcomp_typ_to_string : FStar_Absyn_Syntax.lcomp  ->  Prims.string = (fun lc -> (let _123_196 = (sli lc.FStar_Absyn_Syntax.eff_name)
in (let _123_195 = (typ_to_string lc.FStar_Absyn_Syntax.res_typ)
in (FStar_Util.format2 "%s %s" _123_196 _123_195))))
and comp_typ_to_string : FStar_Absyn_Syntax.comp  ->  Prims.string = (fun c -> (match (c.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Total (t) -> begin
(let _123_198 = (typ_to_string t)
in (FStar_Util.format1 "Tot %s" _123_198))
end
| FStar_Absyn_Syntax.Comp (c) -> begin
(

let basic = if ((FStar_All.pipe_right c.FStar_Absyn_Syntax.flags (FStar_Util.for_some (fun _32_7 -> (match (_32_7) with
| FStar_Absyn_Syntax.TOTAL -> begin
true
end
| _32_384 -> begin
false
end)))) && (not ((FStar_Options.print_effect_args ())))) then begin
(let _123_200 = (typ_to_string c.FStar_Absyn_Syntax.result_typ)
in (FStar_Util.format1 "Tot %s" _123_200))
end else begin
if ((not ((FStar_Options.print_effect_args ()))) && (FStar_Ident.lid_equals c.FStar_Absyn_Syntax.effect_name FStar_Absyn_Const.effect_ML_lid)) then begin
(typ_to_string c.FStar_Absyn_Syntax.result_typ)
end else begin
if ((not ((FStar_Options.print_effect_args ()))) && (FStar_All.pipe_right c.FStar_Absyn_Syntax.flags (FStar_Util.for_some (fun _32_8 -> (match (_32_8) with
| FStar_Absyn_Syntax.MLEFFECT -> begin
true
end
| _32_388 -> begin
false
end))))) then begin
(let _123_202 = (typ_to_string c.FStar_Absyn_Syntax.result_typ)
in (FStar_Util.format1 "ALL %s" _123_202))
end else begin
if (FStar_Options.print_effect_args ()) then begin
(let _123_206 = (sli c.FStar_Absyn_Syntax.effect_name)
in (let _123_205 = (typ_to_string c.FStar_Absyn_Syntax.result_typ)
in (let _123_204 = (let _123_203 = (FStar_All.pipe_right c.FStar_Absyn_Syntax.effect_args (FStar_List.map effect_arg_to_string))
in (FStar_All.pipe_right _123_203 (FStar_String.concat ", ")))
in (FStar_Util.format3 "%s (%s) %s" _123_206 _123_205 _123_204))))
end else begin
(let _123_208 = (sli c.FStar_Absyn_Syntax.effect_name)
in (let _123_207 = (typ_to_string c.FStar_Absyn_Syntax.result_typ)
in (FStar_Util.format2 "%s (%s)" _123_208 _123_207)))
end
end
end
end
in (

let dec = (let _123_212 = (FStar_All.pipe_right c.FStar_Absyn_Syntax.flags (FStar_List.collect (fun _32_9 -> (match (_32_9) with
| FStar_Absyn_Syntax.DECREASES (e) -> begin
(let _123_211 = (let _123_210 = (exp_to_string e)
in (FStar_Util.format1 " (decreases %s)" _123_210))
in (_123_211)::[])
end
| _32_394 -> begin
[]
end))))
in (FStar_All.pipe_right _123_212 (FStar_String.concat " ")))
in (FStar_Util.format2 "%s%s" basic dec)))
end))
and effect_arg_to_string : (((FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax, (FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Util.either * FStar_Absyn_Syntax.arg_qualifier Prims.option)  ->  Prims.string = (fun e -> (match (e) with
| (FStar_Util.Inr (e), _32_400) -> begin
(exp_to_string e)
end
| (FStar_Util.Inl (wp), _32_405) -> begin
(formula_to_string wp)
end))
and formula_to_string : FStar_Absyn_Syntax.typ  ->  Prims.string = (fun phi -> (typ_to_string phi))
and formula_to_string_old_now_unused : (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax  ->  Prims.string = (fun phi -> (

let const_op = (fun f _32_411 -> f)
in (

let un_op = (fun f _32_10 -> (match (_32_10) with
| ((FStar_Util.Inl (t), _32_419))::[] -> begin
(let _123_224 = (formula_to_string t)
in (FStar_Util.format2 "%s %s" f _123_224))
end
| _32_423 -> begin
(FStar_All.failwith "impos")
end))
in (

let bin_top = (fun f _32_11 -> (match (_32_11) with
| ((FStar_Util.Inl (t1), _32_435))::((FStar_Util.Inl (t2), _32_430))::[] -> begin
(let _123_230 = (formula_to_string t1)
in (let _123_229 = (formula_to_string t2)
in (FStar_Util.format3 "%s %s %s" _123_230 f _123_229)))
end
| _32_439 -> begin
(FStar_All.failwith "Impos")
end))
in (

let bin_eop = (fun f _32_12 -> (match (_32_12) with
| ((FStar_Util.Inr (e1), _32_451))::((FStar_Util.Inr (e2), _32_446))::[] -> begin
(let _123_236 = (exp_to_string e1)
in (let _123_235 = (exp_to_string e2)
in (FStar_Util.format3 "%s %s %s" _123_236 f _123_235)))
end
| _32_455 -> begin
(FStar_All.failwith "impos")
end))
in (

let ite = (fun _32_13 -> (match (_32_13) with
| ((FStar_Util.Inl (t1), _32_470))::((FStar_Util.Inl (t2), _32_465))::((FStar_Util.Inl (t3), _32_460))::[] -> begin
(let _123_241 = (formula_to_string t1)
in (let _123_240 = (formula_to_string t2)
in (let _123_239 = (formula_to_string t3)
in (FStar_Util.format3 "if %s then %s else %s" _123_241 _123_240 _123_239))))
end
| _32_474 -> begin
(FStar_All.failwith "impos")
end))
in (

let eq_op = (fun _32_14 -> (match (_32_14) with
| ((FStar_Util.Inl (t1), _32_495))::((FStar_Util.Inl (t2), _32_490))::((FStar_Util.Inr (e1), _32_485))::((FStar_Util.Inr (e2), _32_480))::[] -> begin
if (FStar_Options.print_implicits ()) then begin
(let _123_247 = (typ_to_string t1)
in (let _123_246 = (typ_to_string t2)
in (let _123_245 = (exp_to_string e1)
in (let _123_244 = (exp_to_string e2)
in (FStar_Util.format4 "Eq2 %s %s %s %s" _123_247 _123_246 _123_245 _123_244)))))
end else begin
(let _123_249 = (exp_to_string e1)
in (let _123_248 = (exp_to_string e2)
in (FStar_Util.format2 "%s == %s" _123_249 _123_248)))
end
end
| ((FStar_Util.Inr (e1), _32_506))::((FStar_Util.Inr (e2), _32_501))::[] -> begin
(let _123_251 = (exp_to_string e1)
in (let _123_250 = (exp_to_string e2)
in (FStar_Util.format2 "%s == %s" _123_251 _123_250)))
end
| _32_510 -> begin
(FStar_All.failwith "Impossible")
end))
in (

let connectives = ((FStar_Absyn_Const.and_lid, (bin_top "/\\")))::((FStar_Absyn_Const.or_lid, (bin_top "\\/")))::((FStar_Absyn_Const.imp_lid, (bin_top "==>")))::((FStar_Absyn_Const.iff_lid, (bin_top "<==>")))::((FStar_Absyn_Const.ite_lid, ite))::((FStar_Absyn_Const.not_lid, (un_op "~")))::((FStar_Absyn_Const.eqT_lid, (bin_top "==")))::((FStar_Absyn_Const.eq2_lid, eq_op))::((FStar_Absyn_Const.true_lid, (const_op "True")))::((FStar_Absyn_Const.false_lid, (const_op "False")))::[]
in (

let fallback = (fun phi -> (match (phi.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_lam (binders, phi) -> begin
(let _123_290 = (binders_to_string " " binders)
in (let _123_289 = (formula_to_string phi)
in (FStar_Util.format2 "(fun %s => %s)" _123_290 _123_289)))
end
| _32_520 -> begin
(typ_to_string phi)
end))
in (match ((FStar_Absyn_Util.destruct_typ_as_formula phi)) with
| None -> begin
(fallback phi)
end
| Some (FStar_Absyn_Util.BaseConn (op, arms)) -> begin
(match ((FStar_All.pipe_right connectives (FStar_List.tryFind (fun _32_530 -> (match (_32_530) with
| (l, _32_529) -> begin
(FStar_Ident.lid_equals op l)
end))))) with
| None -> begin
(fallback phi)
end
| Some (_32_533, f) -> begin
(f arms)
end)
end
| Some (FStar_Absyn_Util.QAll (vars, _32_539, body)) -> begin
(let _123_308 = (binders_to_string " " vars)
in (let _123_307 = (formula_to_string body)
in (FStar_Util.format2 "(forall %s. %s)" _123_308 _123_307)))
end
| Some (FStar_Absyn_Util.QEx (vars, _32_546, body)) -> begin
(let _123_310 = (binders_to_string " " vars)
in (let _123_309 = (formula_to_string body)
in (FStar_Util.format2 "(exists %s. %s)" _123_310 _123_309)))
end))))))))))
and exp_to_string : (FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax  ->  Prims.string = (fun x -> (match ((let _123_312 = (FStar_Absyn_Util.compress_exp x)
in _123_312.FStar_Absyn_Syntax.n)) with
| FStar_Absyn_Syntax.Exp_delayed (_32_553) -> begin
(FStar_All.failwith "Impossible")
end
| FStar_Absyn_Syntax.Exp_meta (FStar_Absyn_Syntax.Meta_desugared (e, _32_557)) -> begin
(exp_to_string e)
end
| FStar_Absyn_Syntax.Exp_uvar (uv, t) -> begin
(uvar_e_to_string (uv, t))
end
| FStar_Absyn_Syntax.Exp_bvar (bvv) -> begin
(strBvd bvv.FStar_Absyn_Syntax.v)
end
| FStar_Absyn_Syntax.Exp_fvar (fv, _32_569) -> begin
(sli fv.FStar_Absyn_Syntax.v)
end
| FStar_Absyn_Syntax.Exp_constant (c) -> begin
(FStar_All.pipe_right c const_to_string)
end
| FStar_Absyn_Syntax.Exp_abs (binders, e) -> begin
(let _123_314 = (binders_to_string " " binders)
in (let _123_313 = (FStar_All.pipe_right e exp_to_string)
in (FStar_Util.format2 "(fun %s -> %s)" _123_314 _123_313)))
end
| FStar_Absyn_Syntax.Exp_app (e, args) -> begin
(

let lex = if (FStar_Options.print_implicits ()) then begin
None
end else begin
(reconstruct_lex x)
end
in (match (lex) with
| Some (es) -> begin
(let _123_317 = (let _123_316 = (let _123_315 = (FStar_List.map exp_to_string es)
in (FStar_String.concat "; " _123_315))
in (Prims.strcat "%[" _123_316))
in (Prims.strcat _123_317 "]"))
end
| None -> begin
(

let args' = (let _123_319 = (filter_imp args)
in (FStar_All.pipe_right _123_319 (FStar_List.filter (fun _32_15 -> (match (_32_15) with
| (FStar_Util.Inr (_32_588), _32_591) -> begin
true
end
| _32_594 -> begin
false
end)))))
in if ((is_infix_prim_op e) && ((FStar_List.length args') = 2)) then begin
(let _123_324 = (let _123_320 = (FStar_List.nth args' 0)
in (FStar_All.pipe_right _123_320 arg_to_string))
in (let _123_323 = (FStar_All.pipe_right e infix_prim_op_to_string)
in (let _123_322 = (let _123_321 = (FStar_List.nth args' 1)
in (FStar_All.pipe_right _123_321 arg_to_string))
in (FStar_Util.format3 "(%s %s %s)" _123_324 _123_323 _123_322))))
end else begin
if ((is_unary_prim_op e) && ((FStar_List.length args') = 1)) then begin
(let _123_327 = (FStar_All.pipe_right e unary_prim_op_to_string)
in (let _123_326 = (let _123_325 = (FStar_List.nth args' 0)
in (FStar_All.pipe_right _123_325 arg_to_string))
in (FStar_Util.format2 "(%s %s)" _123_327 _123_326)))
end else begin
(let _123_329 = (FStar_All.pipe_right e exp_to_string)
in (let _123_328 = (args_to_string args)
in (FStar_Util.format2 "(%s %s)" _123_329 _123_328)))
end
end)
end))
end
| FStar_Absyn_Syntax.Exp_match (e, pats) -> begin
(let _123_337 = (FStar_All.pipe_right e exp_to_string)
in (let _123_336 = (let _123_335 = (FStar_All.pipe_right pats (FStar_List.map (fun _32_603 -> (match (_32_603) with
| (p, wopt, e) -> begin
(let _123_334 = (FStar_All.pipe_right p pat_to_string)
in (let _123_333 = (match (wopt) with
| None -> begin
""
end
| Some (w) -> begin
(let _123_331 = (FStar_All.pipe_right w exp_to_string)
in (FStar_Util.format1 "when %s" _123_331))
end)
in (let _123_332 = (FStar_All.pipe_right e exp_to_string)
in (FStar_Util.format3 "%s %s -> %s" _123_334 _123_333 _123_332))))
end))))
in (FStar_Util.concat_l "\n\t" _123_335))
in (FStar_Util.format2 "(match %s with %s)" _123_337 _123_336)))
end
| FStar_Absyn_Syntax.Exp_ascribed (e, t, _32_610) -> begin
(let _123_339 = (FStar_All.pipe_right e exp_to_string)
in (let _123_338 = (FStar_All.pipe_right t typ_to_string)
in (FStar_Util.format2 "(%s:%s)" _123_339 _123_338)))
end
| FStar_Absyn_Syntax.Exp_let (lbs, e) -> begin
(let _123_341 = (lbs_to_string lbs)
in (let _123_340 = (FStar_All.pipe_right e exp_to_string)
in (FStar_Util.format2 "%s in %s" _123_341 _123_340)))
end))
and uvar_e_to_string : (FStar_Absyn_Syntax.uvar_e * FStar_Absyn_Syntax.typ)  ->  Prims.string = (fun _32_620 -> (match (_32_620) with
| (uv, _32_619) -> begin
(let _123_344 = if (FStar_Options.hide_uvar_nums ()) then begin
"?"
end else begin
(let _123_343 = (FStar_Unionfind.uvar_id uv)
in (FStar_Util.string_of_int _123_343))
end
in (Prims.strcat "\'e" _123_344))
end))
and lbs_to_string : FStar_Absyn_Syntax.letbindings  ->  Prims.string = (fun lbs -> (let _123_351 = (let _123_350 = (FStar_All.pipe_right (Prims.snd lbs) (FStar_List.map (fun lb -> (let _123_349 = (lbname_to_string lb.FStar_Absyn_Syntax.lbname)
in (let _123_348 = (FStar_All.pipe_right lb.FStar_Absyn_Syntax.lbtyp typ_to_string)
in (let _123_347 = (FStar_All.pipe_right lb.FStar_Absyn_Syntax.lbdef exp_to_string)
in (FStar_Util.format3 "%s:%s = %s" _123_349 _123_348 _123_347)))))))
in (FStar_Util.concat_l "\n and " _123_350))
in (FStar_Util.format2 "let %s %s" (if (Prims.fst lbs) then begin
"rec"
end else begin
""
end) _123_351)))
and lbname_to_string : FStar_Absyn_Syntax.lbname  ->  Prims.string = (fun x -> (match (x) with
| FStar_Util.Inl (bvd) -> begin
(strBvd bvd)
end
| FStar_Util.Inr (lid) -> begin
(sli lid)
end))
and either_to_string : ((FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax, (FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Util.either  ->  Prims.string = (fun x -> (match (x) with
| FStar_Util.Inl (t) -> begin
(typ_to_string t)
end
| FStar_Util.Inr (e) -> begin
(exp_to_string e)
end))
and either_l_to_string : Prims.string  ->  ((FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax, (FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Util.either Prims.list  ->  Prims.string = (fun delim l -> (let _123_356 = (FStar_All.pipe_right l (FStar_List.map either_to_string))
in (FStar_All.pipe_right _123_356 (FStar_Util.concat_l delim))))
and meta_to_string : FStar_Absyn_Syntax.meta_t  ->  Prims.string = (fun x -> (match (x) with
| FStar_Absyn_Syntax.Meta_refresh_label (t, _32_638, _32_640) -> begin
(let _123_358 = (typ_to_string t)
in (FStar_Util.format1 "(refresh) %s" _123_358))
end
| FStar_Absyn_Syntax.Meta_labeled (t, l, _32_646, _32_648) -> begin
(let _123_359 = (typ_to_string t)
in (FStar_Util.format2 "(labeled \"%s\") %s" l _123_359))
end
| FStar_Absyn_Syntax.Meta_named (_32_652, l) -> begin
(sli l)
end
| FStar_Absyn_Syntax.Meta_pattern (t, ps) -> begin
(let _123_361 = (pats_to_string ps)
in (let _123_360 = (FStar_All.pipe_right t typ_to_string)
in (FStar_Util.format2 "{:pattern %s} %s" _123_361 _123_360)))
end
| FStar_Absyn_Syntax.Meta_slack_formula (t1, t2, _32_663) -> begin
(let _123_363 = (formula_to_string t1)
in (let _123_362 = (formula_to_string t2)
in (FStar_Util.format2 "%s /\\ %s" _123_363 _123_362)))
end))
and pats_to_string : FStar_Absyn_Syntax.arg Prims.list Prims.list  ->  Prims.string = (fun ps -> (let _123_367 = (FStar_All.pipe_right ps (FStar_List.map (fun e -> (let _123_366 = (FStar_All.pipe_right e (FStar_List.map arg_to_string))
in (FStar_All.pipe_right _123_366 (FStar_String.concat "; "))))))
in (FStar_All.pipe_right _123_367 (FStar_String.concat " \\/ "))))
and kind_to_string : FStar_Absyn_Syntax.knd  ->  Prims.string = (fun x -> (match ((let _123_369 = (FStar_Absyn_Util.compress_kind x)
in _123_369.FStar_Absyn_Syntax.n)) with
| FStar_Absyn_Syntax.Kind_lam (_32_670) -> begin
(FStar_All.failwith "Impossible")
end
| FStar_Absyn_Syntax.Kind_delayed (_32_673) -> begin
(FStar_All.failwith "Impossible")
end
| FStar_Absyn_Syntax.Kind_uvar (uv, args) -> begin
(uvar_k_to_string' (uv, args))
end
| FStar_Absyn_Syntax.Kind_type -> begin
"Type"
end
| FStar_Absyn_Syntax.Kind_effect -> begin
"Effect"
end
| FStar_Absyn_Syntax.Kind_abbrev ((n, args), k) -> begin
if (FStar_Options.print_real_names ()) then begin
(kind_to_string k)
end else begin
(let _123_371 = (sli n)
in (let _123_370 = (args_to_string args)
in (FStar_Util.format2 "%s %s" _123_371 _123_370)))
end
end
| FStar_Absyn_Syntax.Kind_arrow (binders, k) -> begin
(let _123_373 = (binders_to_string " -> " binders)
in (let _123_372 = (FStar_All.pipe_right k kind_to_string)
in (FStar_Util.format2 "(%s -> %s)" _123_373 _123_372)))
end
| FStar_Absyn_Syntax.Kind_unknown -> begin
"_"
end))
and uvar_k_to_string = (fun uv -> (let _123_375 = if (FStar_Options.hide_uvar_nums ()) then begin
"?"
end else begin
(let _123_374 = (FStar_Unionfind.uvar_id uv)
in (FStar_Util.string_of_int _123_374))
end
in (Prims.strcat "\'k_" _123_375)))
and uvar_k_to_string' : ((FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax FStar_Absyn_Syntax.uvar_basis FStar_Unionfind.uvar * (((FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax, (FStar_Absyn_Syntax.exp', (FStar_Absyn_Syntax.typ', (FStar_Absyn_Syntax.knd', Prims.unit) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Absyn_Syntax.syntax) FStar_Util.either * FStar_Absyn_Syntax.arg_qualifier Prims.option) Prims.list)  ->  Prims.string = (fun _32_695 -> (match (_32_695) with
| (uv, args) -> begin
(

let str = if (FStar_Options.hide_uvar_nums ()) then begin
"?"
end else begin
(let _123_377 = (FStar_Unionfind.uvar_id uv)
in (FStar_Util.string_of_int _123_377))
end
in (let _123_378 = (args_to_string args)
in (FStar_Util.format2 "(\'k_%s %s)" str _123_378)))
end))
and pat_to_string : FStar_Absyn_Syntax.pat  ->  Prims.string = (fun x -> (match (x.FStar_Absyn_Syntax.v) with
| FStar_Absyn_Syntax.Pat_cons (l, _32_700, pats) -> begin
(let _123_383 = (sli l.FStar_Absyn_Syntax.v)
in (let _123_382 = (let _123_381 = (FStar_List.map (fun _32_706 -> (match (_32_706) with
| (x, b) -> begin
(

let p = (pat_to_string x)
in if b then begin
(Prims.strcat "#" p)
end else begin
p
end)
end)) pats)
in (FStar_All.pipe_right _123_381 (FStar_String.concat " ")))
in (FStar_Util.format2 "(%s %s)" _123_383 _123_382)))
end
| FStar_Absyn_Syntax.Pat_dot_term (x, _32_710) -> begin
(let _123_384 = (strBvd x.FStar_Absyn_Syntax.v)
in (FStar_Util.format1 ".%s" _123_384))
end
| FStar_Absyn_Syntax.Pat_dot_typ (x, _32_715) -> begin
(let _123_385 = (strBvd x.FStar_Absyn_Syntax.v)
in (FStar_Util.format1 ".\'%s" _123_385))
end
| FStar_Absyn_Syntax.Pat_var (x) -> begin
(strBvd x.FStar_Absyn_Syntax.v)
end
| FStar_Absyn_Syntax.Pat_tvar (a) -> begin
(strBvd a.FStar_Absyn_Syntax.v)
end
| FStar_Absyn_Syntax.Pat_constant (c) -> begin
(const_to_string c)
end
| FStar_Absyn_Syntax.Pat_wild (_32_725) -> begin
"_"
end
| FStar_Absyn_Syntax.Pat_twild (_32_728) -> begin
"\'_"
end
| FStar_Absyn_Syntax.Pat_disj (ps) -> begin
(let _123_386 = (FStar_List.map pat_to_string ps)
in (FStar_Util.concat_l " | " _123_386))
end))


let subst_to_string = (fun subst -> (let _123_394 = (let _123_393 = (FStar_List.map (fun _32_16 -> (match (_32_16) with
| FStar_Util.Inl (a, t) -> begin
(let _123_390 = (strBvd a)
in (let _123_389 = (typ_to_string t)
in (FStar_Util.format2 "(%s -> %s)" _123_390 _123_389)))
end
| FStar_Util.Inr (x, e) -> begin
(let _123_392 = (strBvd x)
in (let _123_391 = (exp_to_string e)
in (FStar_Util.format2 "(%s -> %s)" _123_392 _123_391)))
end)) subst)
in (FStar_All.pipe_right _123_393 (FStar_String.concat ", ")))
in (FStar_All.pipe_left (FStar_Util.format1 "{%s}") _123_394)))


let freevars_to_string : FStar_Absyn_Syntax.freevars  ->  Prims.string = (fun fvs -> (

let f = (fun l -> (let _123_400 = (let _123_399 = (FStar_All.pipe_right l FStar_Util.set_elements)
in (FStar_All.pipe_right _123_399 (FStar_List.map (fun t -> (strBvd t.FStar_Absyn_Syntax.v)))))
in (FStar_All.pipe_right _123_400 (FStar_String.concat ", "))))
in (let _123_402 = (f fvs.FStar_Absyn_Syntax.ftvs)
in (let _123_401 = (f fvs.FStar_Absyn_Syntax.fxvs)
in (FStar_Util.format2 "ftvs={%s}, fxvs={%s}" _123_402 _123_401)))))


let qual_to_string : FStar_Absyn_Syntax.qualifier  ->  Prims.string = (fun _32_17 -> (match (_32_17) with
| FStar_Absyn_Syntax.Logic -> begin
"logic"
end
| FStar_Absyn_Syntax.Opaque -> begin
"opaque"
end
| FStar_Absyn_Syntax.Discriminator (_32_752) -> begin
"discriminator"
end
| FStar_Absyn_Syntax.Projector (_32_755) -> begin
"projector"
end
| FStar_Absyn_Syntax.RecordType (ids) -> begin
(let _123_407 = (let _123_406 = (FStar_All.pipe_right ids (FStar_List.map (fun lid -> lid.FStar_Ident.ident.FStar_Ident.idText)))
in (FStar_All.pipe_right _123_406 (FStar_String.concat ", ")))
in (FStar_Util.format1 "record(%s)" _123_407))
end
| _32_761 -> begin
"other"
end))


let quals_to_string : FStar_Absyn_Syntax.qualifier Prims.list  ->  Prims.string = (fun quals -> (let _123_410 = (FStar_All.pipe_right quals (FStar_List.map qual_to_string))
in (FStar_All.pipe_right _123_410 (FStar_String.concat " "))))


let rec sigelt_to_string : FStar_Absyn_Syntax.sigelt  ->  Prims.string = (fun x -> (match (x) with
| FStar_Absyn_Syntax.Sig_pragma (FStar_Absyn_Syntax.ResetOptions (None), _32_767) -> begin
"#reset-options"
end
| FStar_Absyn_Syntax.Sig_pragma (FStar_Absyn_Syntax.ResetOptions (Some (s)), _32_774) -> begin
(FStar_Util.format1 "#reset-options \"%s\"" s)
end
| FStar_Absyn_Syntax.Sig_pragma (FStar_Absyn_Syntax.SetOptions (s), _32_780) -> begin
(FStar_Util.format1 "#set-options \"%s\"" s)
end
| FStar_Absyn_Syntax.Sig_tycon (lid, tps, k, _32_787, _32_789, quals, _32_792) -> begin
(let _123_415 = (quals_to_string quals)
in (let _123_414 = (binders_to_string " " tps)
in (let _123_413 = (kind_to_string k)
in (FStar_Util.format4 "%s type %s %s : %s" _123_415 lid.FStar_Ident.str _123_414 _123_413))))
end
| FStar_Absyn_Syntax.Sig_typ_abbrev (lid, tps, k, t, _32_800, _32_802) -> begin
(let _123_418 = (binders_to_string " " tps)
in (let _123_417 = (kind_to_string k)
in (let _123_416 = (typ_to_string t)
in (FStar_Util.format4 "type %s %s : %s = %s" lid.FStar_Ident.str _123_418 _123_417 _123_416))))
end
| FStar_Absyn_Syntax.Sig_datacon (lid, t, _32_808, _32_810, _32_812, _32_814) -> begin
(let _123_419 = (typ_to_string t)
in (FStar_Util.format2 "datacon %s : %s" lid.FStar_Ident.str _123_419))
end
| FStar_Absyn_Syntax.Sig_val_decl (lid, t, quals, _32_821) -> begin
(let _123_421 = (quals_to_string quals)
in (let _123_420 = (typ_to_string t)
in (FStar_Util.format3 "%s val %s : %s" _123_421 lid.FStar_Ident.str _123_420)))
end
| FStar_Absyn_Syntax.Sig_assume (lid, f, _32_827, _32_829) -> begin
(let _123_422 = (typ_to_string f)
in (FStar_Util.format2 "val %s : %s" lid.FStar_Ident.str _123_422))
end
| FStar_Absyn_Syntax.Sig_let (lbs, _32_834, _32_836, b) -> begin
(lbs_to_string lbs)
end
| FStar_Absyn_Syntax.Sig_main (e, _32_842) -> begin
(let _123_423 = (exp_to_string e)
in (FStar_Util.format1 "let _ = %s" _123_423))
end
| FStar_Absyn_Syntax.Sig_bundle (ses, _32_847, _32_849, _32_851) -> begin
(let _123_424 = (FStar_List.map sigelt_to_string ses)
in (FStar_All.pipe_right _123_424 (FStar_String.concat "\n")))
end
| FStar_Absyn_Syntax.Sig_new_effect (_32_855) -> begin
"new_effect { ... }"
end
| FStar_Absyn_Syntax.Sig_sub_effect (_32_858) -> begin
"sub_effect ..."
end
| FStar_Absyn_Syntax.Sig_kind_abbrev (_32_861) -> begin
"kind ..."
end
| FStar_Absyn_Syntax.Sig_effect_abbrev (l, tps, c, _32_867, _32_869) -> begin
(let _123_427 = (sli l)
in (let _123_426 = (binders_to_string " " tps)
in (let _123_425 = (comp_typ_to_string c)
in (FStar_Util.format3 "effect %s %s = %s" _123_427 _123_426 _123_425))))
end))


let format_error : FStar_Range.range  ->  Prims.string  ->  Prims.string = (fun r msg -> (let _123_432 = (FStar_Range.string_of_range r)
in (FStar_Util.format2 "%s: %s\n" _123_432 msg)))


let rec sigelt_to_string_short : FStar_Absyn_Syntax.sigelt  ->  Prims.string = (fun x -> (match (x) with
| FStar_Absyn_Syntax.Sig_let ((_32_876, ({FStar_Absyn_Syntax.lbname = FStar_Util.Inr (l); FStar_Absyn_Syntax.lbtyp = t; FStar_Absyn_Syntax.lbeff = _32_880; FStar_Absyn_Syntax.lbdef = _32_878})::[]), _32_888, _32_890, _32_892) -> begin
(let _123_435 = (typ_to_string t)
in (FStar_Util.format2 "let %s : %s" l.FStar_Ident.str _123_435))
end
| _32_896 -> begin
(let _123_438 = (let _123_437 = (FStar_Absyn_Util.lids_of_sigelt x)
in (FStar_All.pipe_right _123_437 (FStar_List.map (fun l -> l.FStar_Ident.str))))
in (FStar_All.pipe_right _123_438 (FStar_String.concat ", ")))
end))


let rec modul_to_string : FStar_Absyn_Syntax.modul  ->  Prims.string = (fun m -> (let _123_443 = (sli m.FStar_Absyn_Syntax.name)
in (let _123_442 = (let _123_441 = (FStar_List.map sigelt_to_string m.FStar_Absyn_Syntax.declarations)
in (FStar_All.pipe_right _123_441 (FStar_String.concat "\n")))
in (FStar_Util.format2 "module %s\n%s" _123_443 _123_442))))




