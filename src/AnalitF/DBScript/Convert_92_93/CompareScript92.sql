alter table analitf.rejects
  add key `IDX_Rejects_Name` (`Name`), 
  add key `IDX_Rejects_ProductId` (`ProductId`),
  add key `IDX_Rejects_SERIES` (`SERIES`);

alter table analitf.documentbodies
  add key `IDX_DocumentBodies_Product` (`Product`), 
  add key `IDX_DocumentBodies_ProductId` (`ProductId`),
  add key `IDX_DocumentBodies_SerialNumber` (`SerialNumber`),
  add key `IDX_DocumentBodies_RejectId` (`RejectId`);

update analitf.params set ProviderMDBVersion = 93 where id = 0;