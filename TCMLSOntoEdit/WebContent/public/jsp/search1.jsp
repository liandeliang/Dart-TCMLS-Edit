<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<head>	
	<script type='text/javascript' src='/TFGWProject/dwr/interface/QueryData.js'></script>
  	<script type='text/javascript' src='/TFGWProject/dwr/interface/Tree.js'></script>
  	<script type='text/javascript' src='/TFGWProject/dwr/engine.js'></script>
  	<script type='text/javascript' src='/TFGWProject/dwr/util.js'></script>
  	<script type='text/javascript' src='/TFGWProject/public/js/searchTree.js'></script>
  	<link rel="stylesheet" href="../css/search.css">
  	
	<script language="javascript">
		//是否在搜索状态
		var isSearch=false;
		var searchValue = new Array(4);
		var isJMZ = false;
		
		//显示窗口的Document对象
		var infDoc=top.frames["infFrame"].document;
		var infFrame=top.frames["infFrame"];
		var btnColor="#98E1E7";
		var bkColor="#E3F9F9";
		var onSearch=false; //是否在搜索状态，该页只有两种状态，搜索状态和导航状态，分别对应该值的"1"和"0"
		var innerHTMLSearch;
		var innerHTMLNavigator;
		var infTab=top.frames["infFrame"].document.getElementById("infTable");
		
		document.attachEvent("onmouseover",mouseOverLeaves);
		document.attachEvent("onmouseout",mouseOutLeaves);
		
		function mouseOverLeaves(event){
			var ele = event.srcElement;
			
			if(ele.className == "treeLeaves"){
				ele.style.color = "blue";
			}
			else if(ele.className == "ctrlBtn"){
				ele.style.color = "blue";
				ele.style.background = btnColor;
			}
		}
		
		function mouseOutLeaves(event){
	
			var ele = event.srcElement;
			
			if(ele.className == "treeLeaves"){
				ele.style.color = "black";
			}
			else if(ele.className == "ctrlBtn"){
				ele.style.background = bkColor;
				ele.style.color = "black";
			}
		}

		//检查输入数值是否为数字
		function IsNumber(str) { 
			var pattern = /^[0-9]/; 
			return pattern.test(str); 
		} 
		
		//改变浏览模式模式
		function openNavigator(node,nodeType){
			var btns = new Array(4);
			btns[0] = document.getElementById("diseaseBtn");
			btns[1] = document.getElementById("expertBtn");
			btns[2] = document.getElementById("hospitalBtn");
			btns[3] = document.getElementById("searchBtn");
			var diseaseTab = document.getElementById("diseaseTab");
			var expertTab = document.getElementById("expertTab");
			var hospitalTab = document.getElementById("hospitalTab");
			var schTab = document.getElementById("searchTab");
	
	
			//重绘搜索按钮
			for(var i = 0; i < btns.length; i++){
				btns[i].style.background = bkColor;
			}
			node.style.background = btnColor;
			
			diseaseTab.style.display = "none";
			expertTab.style.display = "none";
			hospitalTab.style.display = "none";
			searchTab.style.display = "none";
			//根据按下的按钮，改变浏览模式
			if(nodeType == "disease"){
				//如果在急门诊辅助浏览模式，则重置浏览栏
				if(isJMZ){
					infDoc.getElementById("mainTableDiv").style.display = "";
					infDoc.getElementById("jmzDiv").style.display = "none";
					
					isJMZ = false;
				}
				
				window.status="疾病信息导航";	
				diseaseTab.style.display = "block";
			}
			else if(nodeType == "expert"){
				//如果在急门诊辅助浏览模式，则重置浏览栏
				if(isJMZ){
					infDoc.getElementById("mainTableDiv").style.display = "";
					infDoc.getElementById("jmzDiv").style.display = "none";
					
					isJMZ = false;
				}			
			
				window.status="专家信息导航";	
				expertTab.style.display = "block";
			}
			else if(nodeType == "hospital"){
				//如果在急门诊辅助浏览模式，则重置浏览栏
				if(isJMZ){
					infDoc.getElementById("mainTableDiv").style.display = "";
					infDoc.getElementById("jmzDiv").style.display = "none";
					
					isJMZ = false;
				}			
			
				window.status="医院信息导航";	
				hospitalTab.style.display = "block";
			}
			else if(nodeType == "search"){
				//如果在急门诊辅助浏览模式，则重置浏览栏
				if(isJMZ){
					infDoc.getElementById("mainTableDiv").style.display = "";
					infDoc.getElementById("jmzDiv").style.display = "none";
					
					isJMZ = false;
				}			
			
				window.status="搜索模式";	
				searchTab.style.display = "block";
			}	
		}
	
		//改变搜索对象{疾病,专家,医院}
		function changeSearch(e, num){
			//得到三个输入对象
			var node = new Array(3);
			node[0] = document.getElementById("searchDisease");
			node[1] = document.getElementById("searchExpert");
			node[2] = document.getElementById("searchHospital");			
		
			if(node[num].style.display == "none"){
				for(var i = 0; i < 3; i++){
					if(i == num){
						node[i].style.display = "block";
					}
					else{
						node[i].style.display = "none";
					}
				}
			}
		}
		
		function search(){
			infFrame.search();
		}
		
		//通过选择按钮改变搜索项
		function selectCheckBox(node, DBName){
			if(DBName=="expertData"){
				if(node.checked == true){
					document.getElementById("expertDate1").disabled = false;
					document.getElementById("expertDate2").disabled = false;
				}
				else{
					document.getElementById("expertDate1").disabled = true;
					document.getElementById("expertDate2").disabled = true;
				}
			}
		}
		
		//根据搜索的结果绘制数据
		function drawTable(result){	
			isSearch=false;
			infFrame.showPic(false);	
				
			//infDoc.getElementById("showTable").innerHTML = "test";
			for(var i = 0; i < result.length; i++){
				if(result[i] == null){
					result[i] = "<h4 align=center>该数据库不支持当前的搜索条件</h4>";
				}
			}
			
			infDoc.getElementById("showTableJIB").innerHTML = result[0];
			infDoc.getElementById("showTableJMZ").innerHTML = result[1];
			infDoc.getElementById("showTableZDFZ").innerHTML = result[2];
			infDoc.getElementById("showTableZYBFZ").innerHTML = result[3];
			infDoc.getElementById("showTableZCFG").innerHTML = result[4];
			infDoc.getElementById("showTableYJYA").innerHTML = result[5];
			infDoc.getElementById("showTableZLBZ").innerHTML = result[6];
		}
		
		//根据指定的数据库类型绘制单个数据库
		function drawTableByType(type, result){
			isSearch=false;
			infFrame.showPic(false);		
			var i, j;
			var tabViews = new Array(7);
					
			tabViews[0] = infDoc.getElementById("showTableJIB");
			tabViews[1] = infDoc.getElementById("showTableJMZ");
			tabViews[2] = infDoc.getElementById("showTableZDFZ");
			tabViews[3] = infDoc.getElementById("showTableZYBFZ");
			tabViews[4] = infDoc.getElementById("showTableZCFG");
			tabViews[5] = infDoc.getElementById("showTableYJYA");
			tabViews[6] = infDoc.getElementById("showTableZLBZ");
			tabViews[7] = infDoc.getElementById("showTableExpert");
			tabViews[8] = infDoc.getElementById("showTableHospital");
	
			if(type == "JIB" || type == "C_JIB"){
				type = "JIB";
				infDoc.getElementById("showTable" + type).innerHTML = result;
				
				j = 0;
				for(i = 0; i < tabViews.length; i+=1){
					if(i == j){
						tabViews[i].style.display = "";
					}
					else if(i != j){
						tabViews[i].style.display = "none";
					}
				}
			}
			else if(type == "JMZ_JB" || type == "JMZ"){
				type = "JMZ";
				infDoc.getElementById("showTable" + type).innerHTML = result;
				
				j = 1;
				for(i = 0; i < tabViews.length; i+=1){
					if(i == j){
						tabViews[i].style.display = "";
					}
					else if(i != j){
						tabViews[i].style.display = "none";
					}
				}
			}
			else if(type == "TFGW_ZDFZ" || type == "ZDFZ"){
				type = "ZDFZ";
				infDoc.getElementById("showTable" + type).innerHTML = result;
				
				j = 2;
				for(i = 0; i < tabViews.length; i+=1){
					if(i == j){
						tabViews[i].style.display = "";
					}
					else if(i != j){
						tabViews[i].style.display = "none";
					}
				}
			}
			else if(type == "TFGW_ZYBFZ" || type == "ZYBFZ"){
				type = "ZYBFZ";
				infDoc.getElementById("showTable" + type).innerHTML = result;
				
				j = 3;
				for(i = 0; i < tabViews.length; i+=1){
					if(i == j){
						tabViews[i].style.display = "";
					}
					else if(i != j){
						tabViews[i].style.display = "none";
					}
				}
			}
			else if(type == "TFGW_ZCFG" || type == "ZCFG"){
				type = "ZCFG";
				infDoc.getElementById("showTable" + type).innerHTML = result;
				
				j = 4;
				for(i = 0; i < tabViews.length; i+=1){
					if(i == j){
						tabViews[i].style.display = "";
					}
					else if(i != j){
						tabViews[i].style.display = "none";
					}
				}
			}
			else if(type == "TFGW_YJYA" || type == "YJYA"){
				type = "YJYA";
				infDoc.getElementById("showTable" + type).innerHTML = result;
				
				j = 5;
				for(i = 0; i < tabViews.length; i+=1){
					if(i == j){
						tabViews[i].style.display = "";
					}
					else if(i != j){
						tabViews[i].style.display = "none";
					}
				}
			}
			else if(type == "ZYBZZLBZ"){
				type = "ZLBZ";
				infDoc.getElementById("showTable" + type).innerHTML = result;
				
				j = 6;
				for(i = 0; i < tabViews.length; i+=1){
					if(i == j){
						tabViews[i].style.display = "";
					}
					else if(i != j){
						tabViews[i].style.display = "none";
					}
				}
			}
			else if(type == "Expert" || type == "BJWSZY_RENYUAN"){
				type = "Expert";
				infDoc.getElementById("showTable" + type).innerHTML = result;
				
				j = 7;
				for(i = 0; i < tabViews.length; i+=1){
					if(i == j){
						tabViews[i].style.display = "";
					}
					else if(i != j){
						tabViews[i].style.display = "none";
					}
				}
			}
			else if(type == "Hospital" || type == "BJWSZY_YIYUAN"){
				type = "Hospital";
				infDoc.getElementById("showTable" + type).innerHTML = result;
				
				j = 8;
				for(i = 0; i < tabViews.length; i+=1){
					if(i == j){
						tabViews[i].style.display = "";
					}
					else if(i != j){
						tabViews[i].style.display = "none";
					}
				}
			}
						
			infDoc.getElementById("showTable" + type).innerHTML = result;	
		}
	</script>
</head>

<body bgColor="#F3FFF8" style="cursor:default">
	<table>		
		<tr valign="top">
			<td class="ctrlBtn" id="diseaseBtn" width=50 align="center" bgColor="#98E1E7" OnClick=openNavigator(this,"disease")>疾病</td>
			<td class="ctrlBtn" id="expertBtn" width=50 align="center" OnClick=openNavigator(this,"expert")>医生</td>
			<td class="ctrlBtn" id="hospitalBtn" width=50 align="center" OnClick=openNavigator(this,"hospital")>医院</td>
			<td class="ctrlBtn" id="searchBtn" width=50 align="center" OnClick=openNavigator(this,"search")>搜索</td>				
		</tr>	

		<tr>	
			<table id="ctrlTab" align="left">
				<div id="diseaseTab" style="display:block;">
					<div>
						<img class="DBNameImage" align="absmiddle" src="/TFGWProject/public/images/Tplus.gif" OnClick=openTree(this,"JMZ_JB","1")></img>
						<span name="insertPoint">急门诊数据库</span>
					</div>		
					<div>
						<img class="DBNameImage" align="absmiddle" src="/TFGWProject/public/images/Tplus.gif" OnClick=openTree(this,"C_JIB","1","")></img>
						<span name="insertPoint">中医基础疾病数据库</span>
					</div>	
					<div>
						<img class="DBNameImage" align="absmiddle" src="/TFGWProject/public/images/Tplus.gif" OnClick=openTree(this,"TFGW_ZDFZ","1")></img>
						<span name="insertPoint">常见中毒防治数据库</span>
					</div>	
					<div>
						<img class="DBNameImage" align="absmiddle" src="/TFGWProject/public/images/Tplus.gif" OnClick=openTree(this,"TFGW_ZYBFZ","1")></img>
						<span name="insertPoint">常见职业病防治数据库</span>
					</div>		
					<div>
						<img class="DBNameImage" align="absmiddle" src="/TFGWProject/public/images/Tplus.gif" OnClick=openTree(this,"TFGW_YJYA","1")></img>
						<span name="insertPoint">突发公卫应急预案数据库</span>
					</div>						
				</div>	
				
				<div id = "expertTab" style="display:none">	
					<img class="DBNameImage" align="absmiddle" src="/TFGWProject/public/images/Tplus.gif" OnClick=openTree(this,"BJWSZY_RENYUAN","1")></img>
					<span name="insertPoint">北京市名医专家数据库</span>
				</div>
				
				<div id = "hospitalTab" style="display:none">	
					<img class="DBNameImage" align="absmiddle" src="/TFGWProject/public/images/Tplus.gif" OnClick=openTree(this,"BJWSZY_YIYUAN","1")></img>
					<span name="insertPoint">医院数据库</span>
				</div>		
						
				<div id="searchTab" style="display:none;">
					<fieldset>
						<legend>搜索对象</legend>
						<input type="radio" name="searchRadio" id="radioDisease" OnClick=changeSearch(this,0) checked>疾病
						<input type="radio" name="searchRadio" id="radioExpert" OnClick=changeSearch(this,1)>专家
						<input type="radio" name="searchRadio" id="radioHospital" OnClick=changeSearch(this,2)>医院
					</fieldset>
					<fieldset id="searchDisease" style="display:block">
						<legend>搜索条件</legend>
							<input type="text" name="textDisease">疾病名称<br><br>
							<input type="text" name="textDisease">病因<br><br>
							<input type="text" name="textDisease">症状<br><br>
							<input type="text" name="textDisease">症候<br><br>					
					</fieldset>
					<fieldset id="searchExpert" style="display:none">
						<legend>搜索条件</legend>
							<input type="text" name="textExpert">专家姓名<br><br>
							<input type="text" name="textExpert">所在科室<br><br>
							<input type="text" name="textExpert">主治疾病<br><br>	
							门诊时间	
							<select id="expertDate1" name="textExpert">
								<option value="周一" selected="selected">周一</option>
								<option value="周二">周二</option>
								<option value="周三">周三</option>
								<option value="周四">周四</option>
								<option value="周五">周五</option>
								<option value="周六">周六</option>
								<option value="周日">周日</option>
							</select>	
							<select id="expertDate2" name="textExpert">
								<option value="上午" selected="selected">上午</option>
								<option value="下午">下午</option>
							</select>		
							<input type="checkbox" id="expertDateCheckBox" checked=true onclick=selectCheckBox(this,"expertData")>
					</fieldset>
					<fieldset id="searchHospital" style="display:none">
						<legend>搜索条件</legend>
							<input type="text" name="textHospital">医院名称<br><br>
							<input type="text" name="textHospital">医院等级<br><br>
							<input type="text" name="textHospital">特色专科<br><br>	
							床位数:
							<input type="text" name="textHospital" size=3>
							至
							<input type="text" name="textHospital" size=3><br><br>					
					</fieldset>
					<p align="center">
						<input type="button" value="搜索" OnClick=search();>
					</p>
				</div>	
			</table>	
		</tr>	
	</table>
</body>