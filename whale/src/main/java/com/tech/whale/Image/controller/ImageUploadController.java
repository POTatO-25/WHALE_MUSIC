package com.tech.whale.Image.controller;

import com.google.auth.oauth2.ServiceAccountCredentials;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
public class ImageUploadController {

    private final Storage storage = StorageOptions.getDefaultInstance().getService();
    private final String BUCKET_NAME = "whalemusic";

    @PostMapping("/uploadImageMessage")
    public ResponseEntity<Map<String, String>> uploadImageMessage(@RequestParam("file") MultipartFile file) throws IOException {
        String fileName = "whale/message/" + System.currentTimeMillis() + "_" + file.getOriginalFilename();

        BlobInfo blobInfo = BlobInfo.newBuilder(BUCKET_NAME, fileName).build();
        storage.create(blobInfo, file.getBytes());

        String imageUrl = "https://storage.googleapis.com/" + BUCKET_NAME + "/" + fileName;
        Map<String, String> response = new HashMap<>();
        response.put("imageUrl", imageUrl);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/uploadImageFeed")
    public ResponseEntity<Map<String, String>> uploadImageFeed(@RequestParam("file") MultipartFile file) throws IOException {
        String fileName = "whale/feed/" + System.currentTimeMillis() + "_" + file.getOriginalFilename();

        BlobInfo blobInfo = BlobInfo.newBuilder(BUCKET_NAME, fileName).build();
        storage.create(blobInfo, file.getBytes());

        String imageUrl = "https://storage.googleapis.com/" + BUCKET_NAME + "/" + fileName;
        Map<String, String> response = new HashMap<>();
        response.put("imageUrl", imageUrl);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/uploadImageSetting")
    public ResponseEntity<Map<String, String>> uploadImageSetting(@RequestParam("file") MultipartFile file) {
        Map<String, String> response = new HashMap<>();
        try {
            String fileName = "whale/setting/" + System.currentTimeMillis() + "_" + file.getOriginalFilename();

            BlobInfo blobInfo = BlobInfo.newBuilder(BUCKET_NAME, fileName).build();
            storage.create(blobInfo, file.getBytes());

            String imageUrl = "https://storage.googleapis.com/" + BUCKET_NAME + "/" + fileName;
            response.put("imageUrl", imageUrl);
            response.put("status", "success"); // status 필드 추가

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error"); // 에러 시에도 status 필드 포함
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}