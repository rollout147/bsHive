package com.postGre.bsHive.Adto;

import lombok.Data;

@Data
public class Lctr_Week {
	// 강의주차별
	private String lctr_weeks;	// 주차
	private int lctr_num;		// 강의번호
	private String lctr_ymd;	//강의일자
	private String lctr_plan;	// 강의계획
	private String lctr_date;	// 수업자료
	private int lctrm_num;		// 강의실번호

}