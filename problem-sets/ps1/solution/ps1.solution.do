use "data\neighborhood.dta", clear
tab treatment
sum area_pop_base
gen bisperhh=area_business_total_base/area_pop_base
hist bisperhh

estpost ttest area_* bisperhh, by(treatment)
esttab ., wide cells("mu_1 mu_2 b(star) p" ". . se(par)")

merge 1:m areaid using "data\household_endline1.dta", gen(m1)
merge 1:1 hhid using "data\household_endline2.dta", gen(m2)

est clear
local controls area_pop_base area_debt_total_base area_business_total_base area_exp_pc_mean_base area_literate_head_base area_literate_base

eststo: reg spandana_1 treatment `controls' [pweight=w1], cluster(areaid)
eststo: reg anyloan_1 treatment `controls' [pweight=w1], cluster(areaid)
eststo: reg spandana_2 treatment `controls' [pweight=w2], cluster(areaid)
eststo: reg anyloan_2 treatment `controls' [pweight=w2], cluster(areaid)

esttab, se indicate(controls = area_* _cons) ///
	starlevels(* 0.1 ** 0.05 *** 0.01)


sum spandana_1 anyloan_1 if treatment ==0 [aweight=w1]
sum spandana_2 anyloan_2 if treatment ==0 [aweight=w2]


local controls area_pop_base area_debt_total_base area_business_total_base area_exp_pc_mean_base area_literate_head_base area_literate_base
est clear
eststo: reg total_exp_mo_pc_1 treatment `controls' [pweight=w1], cluster(areaid)
eststo: reg durables_exp_mo_pc_1 treatment `controls' [pweight=w1], cluster(areaid)
eststo: reg temptation_exp_mo_pc_1 treatment `controls' [pweight=w1], cluster(areaid)
eststo: reg total_exp_mo_pc_2  treatment `controls' [pweight=w2], cluster(areaid)
eststo: reg durables_exp_mo_pc_2 treatment `controls' [pweight=w2], cluster(areaid)
eststo: reg temptation_exp_mo_pc_2 treatment `controls' [pweight=w2], cluster(areaid)
esttab, se indicate(controls = area_* _cons) starlevels(* 0.1 ** 0.05 *** 0.01)

est clear
qui {
	eststo: reg total_exp_mo_pc_1 treatment  [pweight=w1], cluster(areaid)
	eststo: reg durables_exp_mo_pc_1 treatment [pweight=w1], cluster(areaid)
	eststo: reg temptation_exp_mo_pc_1 treatment [pweight=w1], cluster(areaid)
	eststo: reg total_exp_mo_pc_2  treatment [pweight=w2], cluster(areaid)
	eststo: reg durables_exp_mo_pc_2 treatment [pweight=w2], cluster(areaid)
	eststo: reg temptation_exp_mo_pc_2 treatment [pweight=w2], cluster(areaid)
}
esttab, se starlevels(* 0.1 ** 0.05 *** 0.01)


est clear
drop if treatment==1
local controls area_pop_base area_debt_total_base area_business_total_base area_exp_pc_mean_base area_literate_head_base area_literate_base
eststo: reg total_exp_mo_pc_2 anyloan_2 `controls' [pweight=w2], cluster(areaid)
eststo: reg durables_exp_mo_pc_2 anyloan_2 `controls' [pweight=w2], cluster(areaid)
eststo: reg temptation_exp_mo_pc_2 anyloan_2 `controls' [pweight=w2], cluster(areaid)
esttab, se indicate(controls = area_* _cons) starlevels(* 0.1 ** 0.05)
