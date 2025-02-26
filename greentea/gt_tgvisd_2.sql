
SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `gt_chat_group`;
CREATE TABLE `gt_chat_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` bigint unsigned NOT NULL,
  `chat_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `chat_id` (`chat_id`),
  CONSTRAINT `gt_chat_group_ibfk_4` FOREIGN KEY (`group_id`) REFERENCES `gt_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `gt_chat_group_ibfk_5` FOREIGN KEY (`chat_id`) REFERENCES `gt_chats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


DROP TABLE IF EXISTS `gt_chat_user`;
CREATE TABLE `gt_chat_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `chat_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `chat_id` (`chat_id`),
  CONSTRAINT `gt_chat_user_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `gt_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `gt_chat_user_ibfk_4` FOREIGN KEY (`chat_id`) REFERENCES `gt_chats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


DROP TABLE IF EXISTS `gt_chats`;
CREATE TABLE `gt_chats` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('chatTypeBasicGroup','chatTypePrivate','chatTypeSecret','chatTypeSupergroup') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '[chatTypePrivate, chatTypeSecret] maps to gt_chat_user. [chatTypeBasicGroup, chatTypeSupergroup] maps to gt_chat_group.',
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci COMMENT='This table is used to track chat and sender. In gt_messages, there are 2 fields that have relation to this table, they are: ["chat_id", "sender_id"].';


DROP TABLE IF EXISTS `gt_groups`;
CREATE TABLE `gt_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tg_group_id` bigint NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tg_group_id` (`tg_group_id`),
  KEY `username` (`username`),
  KEY `link` (`link`),
  KEY `name` (`name`),
  KEY `created_at` (`created_at`),
  KEY `updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


DROP TABLE IF EXISTS `gt_groups_history`;
CREATE TABLE `gt_groups_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `group_id` bigint unsigned NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `link` (`link`),
  KEY `name` (`name`),
  KEY `created_at` (`created_at`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `gt_groups_history_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `gt_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


DROP TABLE IF EXISTS `gt_messages`;
CREATE TABLE `gt_messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `chat_id` bigint unsigned NOT NULL,
  `sender_id` bigint unsigned DEFAULT NULL,
  `tg_msg_id` bigint unsigned NOT NULL,
  `reply_to_tg_msg_id` bigint unsigned DEFAULT NULL,
  `msg_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `has_edited_msg` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_forwarded_msg` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_deleted` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tg_msg_id` (`tg_msg_id`),
  KEY `reply_to_tg_msg_id` (`reply_to_tg_msg_id`),
  KEY `msg_type` (`msg_type`),
  KEY `has_edited_msg` (`has_edited_msg`),
  KEY `is_forwarded_msg` (`is_forwarded_msg`),
  KEY `is_deleted` (`is_deleted`),
  KEY `created_at` (`created_at`),
  KEY `updated_at` (`updated_at`),
  KEY `chat_id` (`chat_id`),
  KEY `sender_id` (`sender_id`),
  CONSTRAINT `gt_messages_ibfk_4` FOREIGN KEY (`chat_id`) REFERENCES `gt_chats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `gt_messages_ibfk_6` FOREIGN KEY (`sender_id`) REFERENCES `gt_senders` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


DROP TABLE IF EXISTS `gt_sender_chat`;
CREATE TABLE `gt_sender_chat` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `group_id` bigint unsigned NOT NULL,
  `sender_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `sender_id` (`sender_id`),
  CONSTRAINT `gt_sender_chat_ibfk_3` FOREIGN KEY (`group_id`) REFERENCES `gt_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `gt_sender_chat_ibfk_4` FOREIGN KEY (`sender_id`) REFERENCES `gt_senders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


DROP TABLE IF EXISTS `gt_sender_user`;
CREATE TABLE `gt_sender_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `sender_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `sender_id` (`sender_id`),
  CONSTRAINT `gt_sender_user_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `gt_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `gt_sender_user_ibfk_4` FOREIGN KEY (`sender_id`) REFERENCES `gt_senders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


DROP TABLE IF EXISTS `gt_senders`;
CREATE TABLE `gt_senders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('messageSenderChat','messageSenderUser') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci COMMENT='https://core.telegram.org/tdlib/docs/classtd_1_1td__api_1_1_message_sender.html';


DROP TABLE IF EXISTS `gt_users`;
CREATE TABLE `gt_users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tg_user_id` bigint unsigned NOT NULL,
  `username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `first_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `last_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_verified` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `is_support` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `is_scam` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `type` enum('bot','deleted','user','unknown') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'unknown',
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tg_user_id` (`tg_user_id`),
  KEY `username` (`username`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `phone` (`phone`),
  KEY `is_verified` (`is_verified`),
  KEY `is_support` (`is_support`),
  KEY `is_scam` (`is_scam`),
  KEY `type` (`type`),
  KEY `created_at` (`created_at`),
  KEY `updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


DROP TABLE IF EXISTS `gt_users_history`;
CREATE TABLE `gt_users_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `first_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `last_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_verified` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `is_support` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `is_scam` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gt_user_id` (`user_id`),
  KEY `username` (`username`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `phone` (`phone`),
  KEY `is_verified` (`is_verified`),
  KEY `is_support` (`is_support`),
  KEY `is_scam` (`is_scam`),
  KEY `created_at` (`created_at`),
  CONSTRAINT `gt_users_history_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `gt_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
