<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>  
<%@ include file="/common/taglibs.jsp" %>  
<%                                       
String path = request.getContextPath();  
%>                                       
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>                                   
<title></title>                          
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
				Dialog.opener().location.reload(); //;= "<%=path%>/supermarket/MarketVedio!list.action";   
				parentDialog.close();             
			});                                 
		} else if(messageType == "exception") { 
			                                    
		}                                     
	}                                       
	                                        
	$(function(){                           
		/* form1表单进行验证 */               
		$("#form1").validate({              
			rules:{                             
			    "marketVedioBean.marketId":{            
			        number:true,range:[0,9999999999]
			    },                              
			    "marketVedioBean.name":{            
			        CNRangeLength:[0,255]
			    },                              
			    "marketVedioBean.picUrl":{            
			        CNRangeLength:[0,255]
			    },                              
			    "marketVedioBean.url":{            
			        CNRangeLength:[0,255]
			    },                              
			    "marketVedioBean.seqNo":{            
			        number:true,range:[0,9999999999]
			    }                              
			},                                  
			messages:{                          
//			    "marketVedioBean.code":{          
//				    required : "",CNRangeLength:""  
//			    },                            
			}                                   
		}); 
		setTimeout(function(){
			$('#file').uploadify({
				'fileObjName':'file',
				'buttonText':'选择文件',
				'method'   :'post',
				'multi'    :false,
				'queueSizeLimit' : 1,
				'auto'     :true,  
				'swf'      : '<%=path%>/js/uploadify/uploadify.swf?pp=1',
				'uploader' : '<%=request.getContextPath()%>/supermarket/MarketVedio!importFile.action',
				'onUploadSuccess' : function(file, data, response) {
					$("#pic").html("<img src='/supermarket_images/market/"+data+"' style='width:100px;height:100px;'/>");
					$("#fileUrl").val(data);
			    }
			});
		},10);                                          
	});                                     
	                                        
	function removeFile() {
	 	Dialog.confirm("确定删除附件吗？", function(){     
		$.ajax({
		 type :"post",
		 url : '<%=request.getContextPath()%>/supermarket/MarketVedio!removeFile.action',
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
<form name="form1" id="form1" action="<%=path %>/supermarket/MarketVedio!addMarketVedio.action" method="post" target="fram" >   
<input type="hidden" name="oper" value="${oper}" />
<input type="hidden" name="marketVedioBean.id" id="id" value="${marketVedioBean.id }"/> 
<input type="hidden" name="marketVedioBean.marketId" id="marketId" value="${marketVedioBean.marketId }"/> 
<span style="display:none;"><input type="hidden" name="marketVedioBean.picUrl" id="fileUrl" value="${marketVedioBean.picUrl }"/></span> 
<table cellpadding="0" cellspacing="0" width="100%" class="GF-grid"> 
  <tr>                                    
    	<td align="right" > 
                            名称<span class="mark"></span>   
        </td>                            
        <td>                             
            <input type="text" name="marketVedioBean.name" id="name"  value="${marketVedioBean.name}" class="GF-field"/>   
        </td>                            
  </tr>                                
  <tr id="upload_pic">  
  		<td align="right">上传简介图片</td>                                     
    	<td><input type="file" name="file" id="file" /><br/>建议图片大小200*200</td>                     
  </tr>  
  <tr>                                    
    	<td align="right">预览简介图片</td>   
    	<td>
    	<div id="pic">
    		<s:if test="#request.marketVedioBean.picUrl!=null && #request.marketVedioBean.picUrl!=''">
	    		<img src='/supermarket_images/market/${marketVedioBean.picUrl }' style='width:100px;height:100px;'/>
	    	</s:if>
	    </div>
    	<input type="button" value="删除" onclick="removeFile()" class="GF-btn" /></td>                     
  </tr>                                  
  <tr>                                    
    	<td align="right" > 
                            链接地址<span class="mark"></span>   
        </td>                            
        <td>                             
            <input type="text" name="marketVedioBean.url" id="url"  value="${marketVedioBean.url}" class="GF-field"/>   
        </td>                            
  </tr>                                
  <tr>                                    
    	<td align="right" > 
                            排序<span class="mark"></span>   
        </td>                            
        <td>                             
            <input type="text" name="marketVedioBean.seqNo" id="seqNo"  value="${marketVedioBean.seqNo}" class="GF-field"/>   
        </td>                            
  </tr>                                
  <tr>                                
      <td>&nbsp;</td>		
      <td><input type="button" name="提交" value="提交" onclick="save();" class="GF-btn"/></td>		
  </tr>                                
</table>                                 
<iframe name="fram" id="fram" style="display:none"></iframe>   
</form>                                  
</body>                                  
</html>                                  
