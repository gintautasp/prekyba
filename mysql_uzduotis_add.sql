ALTER TABLE `prekes_tiekejai` ADD FOREIGN KEY (`id_tiekejo`) REFERENCES `tiekejai`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `prekes_tiekejai` ADD FOREIGN KEY (`id_prekes`) REFERENCES `prekes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `prekes_gavimai` ADD FOREIGN KEY (`barkodas`) REFERENCES `prekes_tiekejai`(`barkodas`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `prekes_pardavimai` ADD `id` INT NOT NULL AUTO_INCREMENT FIRST, ADD PRIMARY KEY (`id`);
ALTER TABLE `prekes_pardavimai` ADD FOREIGN KEY (`id_prekes_gavimo`) REFERENCES `prekes_gavimai`(`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;