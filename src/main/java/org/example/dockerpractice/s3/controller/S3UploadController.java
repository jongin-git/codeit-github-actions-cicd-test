package org.example.dockerpractice.s3.controller;

import lombok.RequiredArgsConstructor;
import org.example.dockerpractice.s3.dto.FileMetadataDto;
import org.example.dockerpractice.s3.service.S3UploadService;
import org.example.dockerpractice.service.FileMetadataService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.net.URI;

@RestController
@RequestMapping("/files")
@RequiredArgsConstructor
public class S3UploadController {
    private final S3UploadService s3;
    private final FileMetadataService metaService;   // ✅ 추가 주입

    @PostMapping("/upload")
    public ResponseEntity<FileMetadataDto> upload(@RequestParam("file") MultipartFile file) {
        var saved = metaService.uploadAndSave(file); // ✅ 업로드 + DB 저장
        var dto = FileMetadataDto.from(saved);
        return ResponseEntity
                .created(URI.create("/files/db/" + saved.getId()))
                .body(dto);
    }
}
