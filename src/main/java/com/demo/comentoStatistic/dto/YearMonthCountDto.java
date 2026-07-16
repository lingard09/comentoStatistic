package com.demo.comentoStatistic.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class YearMonthCountDto {

    private String yearMonth;
    private long totCnt;

}
