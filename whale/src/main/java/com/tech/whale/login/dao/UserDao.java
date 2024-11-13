package com.tech.whale.login.dao;

import com.tech.whale.login.dto.UserDto;
import org.apache.catalina.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

@Mapper
public interface UserDao {
    public void insertUserInfo(UserDto user);
    public void insertUserNotification(String user_id);
    public void insertPageAccessSetting(String user_id);
    public void insertStartPageSetting(String user_id);
    public void insertBlock(String user_id);
    public void insertUserSetting(String user_id);
    public void insertFollow(String user_id);
    public Integer selectFollowId(String user_id);
    public void insertProfile(String user_id, Integer followId);
    public Integer checkAccessId(String user_id);
    public String getPasswordByUsername(String user_id);
    public void saveUser(String user_id, String password, String email);
    Integer existsByUsername(String user_id);
    Integer existsByNickname(String user_nickname);
    Integer existsByEmail(String user_email);
    public void saveResetToken(String user_id, String token);
    public Integer isValidToken(String token);
    public void updatePasswordByToken(String hashedPassword, String token);
    public String getUserIdByEmail(String email);
    List<UserDto> getUsersByEmail(String email);
    public void deleteUserById(@Param("user_id") String userId);
    public Integer getUserStatus(String userId);
    public Date getUserEndDate(String userId);
}
