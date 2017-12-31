<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>  
<%@ include file="/common/taglibs.jsp" %>  
<%                                       
String path = request.getContextPath();  
%>                                       
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>                                   
<title></title>  
<link rel="stylesheet" href="<%=path %>/kindeditor/themes/default/default.css" />
	<link rel="stylesheet" href="<%=path %>/kindeditor/plugins/code/prettify.css" />
	<script charset="utf-8" src="<%=path %>/kindeditor/kindeditor.js"></script>
	<script charset="utf-8" src="<%=path %>/kindeditor/lang/zh_CN.js"></script>
	<script charset="utf-8" src="<%=path %>/kindeditor/plugins/code/prettify.js"></script>
	<link rel="stylesheet" href="<%=path %>/zyupload/skins/zyupload-1.0.0.css " type="text/css">
	<script type="text/javascript" src="<%=path %>/zyupload/zyupload-1.0.0.js"></script>                                           
<script type="text/javascript">        
 var isCommit=false 
	function save(){                        
		if($("#form1").valid()) {           
        if(isCommit==false){   
         isCommit=true       
			form1.submit();                     
      }                 
		}                                     
	}                                       
	                                        
	function result(messageType, message){  
		if(messageType=="error"){        
			Dialog.error(message);				      
		} else if (messageType == "reload_success") {    
			Dialog.alert(message,function(){    
				Dialog.opener().location.reload(); //;= "<%=path%>/supermarket/MarketNews!list.action";   
				parentDialog.close();             
			});                                 
		} else if(messageType == "exception") { 
			                                    
		}                                     
	}                                       
	                                        
	$(function(){ 
		KindEditor.ready(function(K) {
			var editor1 = K.create('textarea[name="marketBean.info"]', {
				allowUpload : true,
				cssPath : '<%=path%>/kindeditor/plugins/code/prettify.css',
				uploadJson : "<%=path%>/kindeditor/jsp/upload_json.jsp?dirName=article",
				fileManagerJson : '<%=path%>/kindeditor/jsp/file_manager_json.jsp',
				allowFileManager : true,
				allowImageUpload : true,
				urlType:'relative',
				afterCreate : function() {
					var self = this;
					K.ctrl(document, 13, function() {
						self.sync();
						if($("#fileUrl").val()==null || $("#fileUrl").val()=="") {
							Dialog.alert("请上传简介图片");
							return;
						}
						if($("#form1").valid()) {
							document.forms['form1'].submit();
						}
					});
					K.ctrl(self.edit.doc, 13, function() {
						self.sync();
						if($("#fileUrl").val()==null || $("#fileUrl").val()=="") {
							Dialog.alert("请上传简介图片");
							return;
						}
						if($("#form1").valid()) {
							document.forms['form1'].submit();
						}
					});
				}
			});
			prettyPrint();
			
			
		});                          
		/* form1表单进行验证 */               
		$("#form1").validate({              
			rules:{                             
			                                 
			    "marketBean.name":{            
			        CNRangeLength:[0,255]
			    }                              
			},                                  
			messages:{                          
//			    "marketNewsBean.code":{          
//				    required : "",CNRangeLength:""  
//			    },                            
			}                                   
		});  


   if(myBrowser()=="IE"){
   		setTimeout(function(){
			$('#file').uploadify({
				'fileObjName':'file',
				'buttonText':'选择文件',
				'method'   :'post',
				'multi'    :false,
				'queueSizeLimit' : 1,
				'auto'     :true,  
				'swf'      : '<%=path%>/js/uploadify/uploadify.swf?pp=1',
				'uploader' : '<%=request.getContextPath()%>/supermarket/Market!importFile.action',
				'onUploadSuccess' : function(file, data, response) {
					$("#pic").html("<img src='/supermarket_images/market/"+data+"' style='width:100px;height:100px;'/>");
					$("#fileUrl").val(data);
			    }
			});

			$("#zyupload").css("display","none");
		},10);
   }else {
   				
				// 初始化插件
				//"js","exe","txt","xls","rar","zip","ppt","pdf","psd" 文件种类
				$("#file").css("display","none");
				$("#zyupload").zyUpload({
					width            :   "650px",                 // 宽度
					height           :   "200px",                 // 宽度
					itemWidth        :   "140px",                 // 文件项的宽度
					itemHeight       :   "115px",                 // 文件项的高度
					url              :   "<%=request.getContextPath()%>/supermarket/Market!importFile.action",  // 上传文件的路径
					fileType         :   ["jpg","png"],// 上传文件的类型
					fileSize         :   51200000,                // 上传文件的大小
					multiple         :   true,                    // 是否可以多个文件上传
					dragDrop         :   false,                   // 是否可以拖动上传文件
					tailor           :   false,                   // 是否可以裁剪图片
					del              :   true,                    // 是否可以删除文件
					finishDel        :   false,  				  // 是否在上传文件完成后删除预览
					/* 外部获得的回调接口 */
					onSelect: function(selectFiles, allFiles){    // 选择文件的回调方法  selectFile:当前选中的文件  allFiles:还没上传的全部文件
						console.info("当前选择了以下文件：");
						console.info(selectFiles);
					},
					onDelete: function(file, files){              // 删除一个文件的回调方法 file:当前删除的文件  files:删除之后的文件
						console.info("当前删除了此文件：");
						console.info(file.name);
					},
					onSuccess: function(file, response){          // 文件上传成功的回调方法
						Dialog.alert("上传成功！");
					$("#pic").html("<img src='/supermarket_images/market/"+response+"' style='width:100px;height:100px;'/>");
					$("#fileUrl").val(data);
						// console.info("此文件上传成功：");
						// console.info(file.name);
						// console.info("此文件上传到服务器地址：");
						// console.info(response);
						// $("#uploadInf").append("<p>上传成功，文件地址是：" + response + "</p>");
					},
					onFailure: function(file, response){          // 文件上传失败的回调方法
						console.info("此文件上传失败：");
						console.info(file.name);
					},
					onComplete: function(response){           	  // 上传完成的回调方法
						console.info("文件上传完成");
						console.info(response);
					}
				});
				
   }




	});                                    
	
	function removeFile() {
	 	Dialog.confirm("确定删除附件吗？", function(){     
		$.ajax({
		 type :"post",
		 url : '<%=request.getContextPath()%>/supermarket/Market!removeFile.action',
				data : {
					"fileName" : $("#fileUrl").val()
				},
				success : function(data) {
					if (data) {
						$("#pic").html("");
						Dialog.alert("删除成功！");
						$("#fileUrl").val("");
					} else {
						Dialog.alert("删除失败！");
					}
				}
			});
}, function() {
	//否      
});                                        
}

                                   
</script> 

 


</head>                                  
<body>                                   
<form name="form1" id="form1" action="<%=path %>/supermarket/Market!addMarket.action" method="post" target="fram" >   
<input type="hidden" name="oper" value="${oper}" />
<input type="hidden" name="marketBean.id" id="id" value="${marketBean.id }"/>
<span style="display:none;"><input type="hidden" name="marketBean.headPic" id="fileUrl" value="${marketBean.headPic }"/></span>  
<table cellpadding="0" cellspacing="0" width="100%" class="GF-grid"> 
  <tr>                                    
    	<td align="right" width="30%" > 
                            名称<span class="mark">*</span>   
        </td>                            
        <td> 
            <s:if test="#session.user.getRole()==1">${marketBean.name}</s:if>                         
            <input <s:if test="#session.user.getRole()==1">hidden</s:if> type="text" name="marketBean.name" id="name"  value="${marketBean.name}" class="GF-field" style="width:800px"/>   
        </td>                            
  </tr>                                
  <tr>                                    
    	<td align="right" > 
                            排名<span class="mark"></span>   
        </td>                            
        <td>             
        	<s:if test="#session.user.getRole()==1">${marketBean.rank}</s:if>                 
            <input <s:if test="#session.user.getRole()==1">hidden</s:if> type="text" name="marketBean.rank" id="rank"  value="${marketBean.rank}" class="GF-field"/>   
        </td>                            
  </tr>
    <tr>                                    
    	<td align="right" > 
                          备注<span class="mark">*</span>   
        </td>                            
        <td>     
        	<s:if test="#session.user.getRole()==1">${marketBean.type}</s:if>                        
            <input <s:if test="#session.user.getRole()==1">hidden</s:if> type="text" name="marketBean.type" id="chaotype"  value="${marketBean.type}" class="GF-field" />
            &nbsp;&nbsp;&nbsp;&nbsp;<span>(填1:先进单位;填2:进步单位;填3:诫勉单位)</span>   
        </td>                            
  </tr>                                
  <tr>  <tr id="upload_pic">  
  		<td align="right">上传简介图片</td>                                     
    	<td><div id="zyupload" class="zyupload"></div><input type="file" name="file" id="file" /><br/>建议图片大小200*200</td>                     
  </tr>  
  <tr>                                    
    	<td align="right">预览简介图片</td>   
    	<td>
    	<div id="pic">
    		<s:if test="#request.marketBean.headPic!=null && #request.marketBean.headPic!=''">
	    		<img src='/supermarket_images/market/${marketBean.headPic }' style='width:100px;height:100px;'/>
	    	</s:if>
	    </div>
    	<input type="button" value="删除" onclick="removeFile()" class="GF-btn" /></td>                     
  </tr>                        
  <tr>                                    
    	<td align="right" > 
                            文本详情<span class="mark">*</span>   
        </td>                            
        <td>                             
        	<textarea cols="120" rows="16" style="width:800px;height:400px;visibility:hidden;" name="marketBean.info" id="content" >${marketBean.info}</textarea>
        </td>                            
  </tr>
  <tr>
     <td align="right" >
     	    	上传测试 
     </td>
   <td>
   	  	<div id="zyupload" class="zyupload"></div>
   </td>
  </tr>                                  
  <tr>                                
      <td>&nbsp;</td>		
      <td><input type="submit" name="提交" value="提交" class="GF-btn"/></td>		
  </tr>                                
</table>                                 
<iframe name="fram" id="fram" style="display:none"></iframe>   
</form>                                  
</body>                                  
</html>                                  
