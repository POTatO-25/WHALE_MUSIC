package com.tech.whale.setting.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class CommentListDto {
	private int post_id;
	private int community_id;
	private String post_tag_text;
	private String post_title;
	private String post_img_url;
	private String post_text;
	private String post_owner_id;
	private int post_comments_id;
	private String post_date;

	private int re_post_id;
	private int re_post_comments_id;
	private Integer re_post_parent_comments_id;
	private String re_post_commenter_image;
	private String re_post_commenter_id;
	private String re_post_comments_text;

	private int feed_id;
	private String feed_img_url;
	private String feed_text;
	private String feed_owner_image;
	private String feed_owner_id;
	private int feed_comments_id;

	private int re_feed_id;
	private int re_feed_comments_id;
	private Integer re_parent_comments_id;
	private String re_commenter_image;
	private String re_commenter_id;
	private String re_feed_comments_text;

}
