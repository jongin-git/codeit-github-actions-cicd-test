package org.example.dockerpractice.repository;


import org.example.dockerpractice.entity.Message;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MessageRepository extends JpaRepository<Message, Long> {
}
