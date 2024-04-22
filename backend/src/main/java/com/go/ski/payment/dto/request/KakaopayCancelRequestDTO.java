package com.go.ski.payment.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;

@Getter
public class KakaopayCancelRequestDTO {
	private String tid;
	@JsonProperty("cancel_amount")
	private Integer cancelAmount;
	@JsonProperty("cancel_tax_free_amount")
	private Integer cancelTaxFreeAmount;
	//사용할 수 있는 것
	/*
	* 어떻게 활용할지 고민하기
	* payload 해당 요청에 대해 저장하고 싶은 값
	* */
}
