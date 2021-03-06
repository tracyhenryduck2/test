package com.zt.supermarket.app;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.avatar.db.DBFactory;
import com.avatar.db.jdbc.JdbcHandler;

public class SuperMarketDAO {
	private JdbcHandler j = DBFactory.create("write");

	public List<Map<String, Object>> getCarouseInfoList() {
		String sql="select * from banner order by seq_no";
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> getMarketVideoList(long id) {
		String sql="select * from market_vedio where market_id="+id;
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> marketNewsList(long id) {
		String sql="select * from market_news where market_id="+id+" order by id desc";
		return j.queryForList(sql);
	}

	public Map<String, Object> marketNewsDetail(long id,String userId) {
		String sql="select * from market_news where id="+id;
		Map<String,Object> map = j.queryForMap(sql);
		if(userId!=null){
			String sql1 = "select count(*) from collection where user_id="+userId+" and type=2 and content_id="+id;
			Long count = j.queryForLong(sql1);
			String sql2 = "select is_cancel from collection where user_id="+userId+" and content_id="+id;
			Long isCancel = j.queryForLong(sql2);
			if(count>0&&isCancel==0){
				map.put("is_shoucang", 1);
			}
			else {
				map.put("is_shoucang", 0);
			}
		}
		
		return map;
	}

	public List<Map<String, Object>> manageColumn() {
		String sql="select * from type where flag=1";
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> manageList(long id) {
		String sql="select a.id,a.title,a.pic_url,a.digest,a.type_id from content a left join type b on a.type_id=b.id where b.id="+id+" order by a.id desc";
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> messageBoardMenu() {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Map<String, Object>> marketRank() {
		String sql="select * from market order by rank asc";
		return j.queryForList(sql);
	}
	
	public List<Map<String, Object>> marketGood() {
		String sql="select * from market where type=1";
		return j.queryForList(sql);
	}
	
	public List<Map<String, Object>> marketAdvanced() {
		String sql="select * from market where type=2";
		return j.queryForList(sql);
	}
	
	public List<Map<String, Object>> marketAdmonishing() {
		String sql="select * from market where type=3";
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> getHQList(long typeId) {
		String sql="select a.id,a.title,a.pic_url,a.digest,a.type_id from content a where type_id="+typeId+" order by a.id desc";
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> getCommentListInfo() {
		String sql="select * from comments order by id desc";
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> getTipsList(long typeId) {
		String sql="select a.id,a.title,a.pic_url,a.digest,a.type_id,a.content from content a where type_id="+typeId+" order by a.id desc";
		return j.queryForList(sql);
	}

	public boolean submitComment(long createTime,long sortId, String comment) {
		String sql="insert into comments (create_time,content,weight) values (?,?,?)";
		Object[] param={createTime,sortId,comment};
		return j.execute(sql, param);
	}

	public List<Map<String, Object>> getVideoList(long id) {
		String sql="select * from market_vedio where market_id="+id;
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> getInformationList(long id) {
		String sql="select * from market_news where market_id="+id;
		return j.queryForList(sql);
	}

	public String getIntroduce(long id) {
		String sql="select * from market where id="+id;
		return j.queryForMap(sql).get("info").toString();
	}

	public List<Map<String, Object>> getPicList(long id) {
		String sql="select * from market_pic where market_id="+id;
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> getQuestionnaire(long surveyId) {
		String sql="select * from question where survey_id="+surveyId;
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> getChooseList(long id) {
		String sql="select * from answer where question_id="+id+" order by sort_id";
		return j.queryForList(sql);
	}
	
	
	public void insertToSelectedSurveyResult(long questionId,long selectedId,long survey_id,String imei,String userid,long storeid){
		
		List<Map<String,Object>> answers = getChooseList(questionId);
		
		
		List<String> sqllist = new ArrayList<String>();

		for(Map<String,Object>map:answers)
		{
			boolean is_check = false;
		    long ds = (Integer)map.get("id"); 
		    if(ds==selectedId)
		    {
		    	is_check=true;
		    }
		    String sql="insert into survey_result (survey_id,imei,user_id,question_id,answer_id,is_check,storeid) values ("
		    	+survey_id+",'"
		    	+imei+"','"
		    	+userid+"',"
		    	+questionId+","
		    	+ds+","
		    	+is_check+","
		    	+storeid
		    	+")";
		   sqllist.add(sql);
		}
		final int size =  sqllist.size();
		String[] arr = (String[])sqllist.toArray(new String[size]);
		j.batchUpdate(arr);
	}
    
	public void insertToNotSelectedSurveyResult(long questionId,long surery_id,String imei,String content){
		
	    String sql="insert into survey_result (survey_id,imei,question_id,answer_content) values ("
	    	+surery_id+","
	    	+imei+","
	    	+questionId+",'"
	    	+content
	    	+"')";
		
		j.execute(sql);
	}
	
//	public List<Map<String,Object>> getAllChoose(long sureyId){
//		String sql="select a.*,b.survey_id from answer a inner join  question b on a.question_id=b.id where b.survey_id="+sureyId;
//		
//		return j.queryForList(sql);
//	}
	
	public List<Map<String, Object>> getTitleList() {
		String sql="select * from type where flag=1 order by id";
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> getList(long titleId) {
		String sql="select a.id,a.title,a.pic_url,a.digest,a.type_id from content a left join type b on a.type_id=b.id where b.id="+titleId+"  order by a.id desc limit 0,3";
		return j.queryForList(sql);
	}

	public List<Map<String, Object>> getMarketList() {
		String sql="select a.id,a.name,a.rank,a.head_pic from market a";
		return j.queryForList(sql);
	}

	public long getMaxSortId() {
		String sql="select max(weight) from comments";
		return j.queryForLong(sql);
	}
	
	public Map<String, Object> getContentById(long contentId,String userId) {
		String sql="select * from content where id="+contentId;
		Map<String,Object> map = j.queryForMap(sql);
		if(userId!=null){
			String sql1 = "select count(*) from collection where user_id="+userId+" and type=1 and content_id="+contentId;
			Long count = j.queryForLong(sql1);
			String sql2 = "select is_cancel from collection where user_id="+userId+" and content_id="+contentId;
			Long isCancel = j.queryForLong(sql2);
			if(count>0&&isCancel==0){
				map.put("is_shoucang", 1);
			}
			else {
				map.put("is_shoucang", 0);
			}
		}
		return map;
	}
}
