<%@ page language="java" pageEncoding="GBK"%>
<%!   
	// ��ĳ���ַ���ת��Ϊint���ͣ�������ת����ʱ�����defualtValue����
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
