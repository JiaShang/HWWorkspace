<%@ page language="java" pageEncoding="GBK"%>
<%!   
	// 将某个字符串转化为int类型，当不能转换的时候采用defualtValue代替
	public int StringToInt(String pram, int defualtValue)
	{
		int resultValue = defualtValue;
		try
		{
			if (null == pram || "null".equals(pram) || pram.length() == 0)
			{
				resultValue = defualtValue;
			}
			else
			{
				resultValue = Integer.parseInt(pram);
			}
		}
		catch(Exception ex)
		{
			resultValue = defualtValue;
		}
		return  resultValue;
	}
%>
