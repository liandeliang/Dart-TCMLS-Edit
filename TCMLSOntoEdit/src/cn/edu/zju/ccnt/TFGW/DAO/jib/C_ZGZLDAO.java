package cn.edu.zju.ccnt.TFGW.DAO.jib;

import java.util.ArrayList;
import java.util.LinkedHashMap;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import cn.edu.zju.ccnt.TFGW.GetFactory;
import cn.edu.zju.ccnt.TFGW.DBConnect.JibDBConn;
import cn.edu.zju.ccnt.TFGW.object.jib.C_ZGZL;

public class C_ZGZLDAO {
	static Logger logger = Logger.getLogger(C_ZGZLDAO.class.getName());	
	
	//通过多重条件来搜索疾病
	public ArrayList<C_ZGZL> searchByJib(String jibName){
		String sql = "select * from C_ZHENGGZL where JBMC like '%" + jibName + "%'";
	
		logger.info("查询：" + sql);
		
		ApplicationContext factory = GetFactory.getFactory();
		JibDBConn conn = (JibDBConn) factory.getBean("jibDBConn");
		
		ArrayList<LinkedHashMap> ResultArray = new ArrayList<LinkedHashMap>();
		ResultArray = conn.DBSelect(sql);

		ArrayList<C_ZGZL> jibList = new ArrayList<C_ZGZL>();
		for (int counter = 0; counter < ResultArray.size(); counter++) {
			C_ZGZL jib = new C_ZGZL();

			if (ResultArray.get(counter).get("ID") != null)
				jib.setID(ResultArray.get(counter).get("ID").toString());
			else
				jib.setID("&nbsp;");

			if (ResultArray.get(counter).get("JBMC") != null)
				jib.setJBMC(ResultArray.get(counter).get("JBMC").toString());
			else
				jib.setJBMC("&nbsp;");

			if (ResultArray.get(counter).get("BZMC") != null)
				jib.setBZMC(ResultArray.get(counter).get("BZMC").toString());
			else
				jib.setBZMC("&nbsp;");

			if (ResultArray.get(counter).get("SF") != null)
				jib.setSF(ResultArray.get(counter).get("SF").toString());
			else
				jib.setSF("&nbsp;");

			if (ResultArray.get(counter).get("SJ") != null)
				jib.setSJ(ResultArray.get(counter).get("SJ").toString());
			else
				jib.setSJ("&nbsp;");
			
			if (ResultArray.get(counter).get("CS") != null)
				jib.setCS(ResultArray.get(counter).get("CS").toString());
			else
				jib.setCS("&nbsp;");
			
			if (ResultArray.get(counter).get("ZZ") != null)
				jib.setZZ(ResultArray.get(counter).get("ZZ").toString());
			else
				jib.setZZ("&nbsp;");
			
			if (ResultArray.get(counter).get("BZ") != null)
				jib.setBZ(ResultArray.get(counter).get("BZ").toString());
			else
				jib.setBZ("&nbsp;");
			
			jibList.add(jib);
		}
		
		return jibList;
	}	
}
