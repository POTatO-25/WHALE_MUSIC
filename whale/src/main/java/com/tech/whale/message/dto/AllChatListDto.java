package com.tech.whale.message.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class AllChatListDto {
    private String user_id;
    private String user_nickname;
    private String user_image_url;
    private String message_read;
    private String last_message_text;

}
