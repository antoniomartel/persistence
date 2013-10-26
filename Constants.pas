unit Constants;

interface


uses

  ClassesRTTI;

const

  { Classes supported in the database. }
  TPersistentClasses: array [0..3] of TClass = (CModel, CAddress, CContact, CCustomer);

  strDBPersistence = 'PERSISTENCE.GDB';

  // Sql strings constants
  strCreateTable = 'create table ';
  strDropTable = 'drop table ';
  strPrimaryKey = ' not null primary key';
  strInsert = 'insert into ';
  strValues = ' values ';
  strUpdate = 'update ';
  strSet = 'set ';
  strWhere = 'where ';
  strSelect = 'select ';
  strFrom = 'from ';
  strAnd = ' and ';
  strDeleteFrom = 'delete from ';
  strId = 'Id';
  strReferences = 'references ';
  strConstraint = 'constraint ';
  strDropConstraint = 'drop constraint ';
  strAlterTable = 'alter table ';
  // Foreign Key actions
  strNoDeleteNoUpdate = 'on delete no action on update no action';
  strDeleteCascadeUpdateCascade = 'on delete cascade on update cascade';
  strNoDeleteUpdateCascade = 'on delete no action on update cascade';
  strDeleteCascadeNoUpdate = 'on delete cascade on update no action';

  // Special characters
  strOpenParenthesis = '(';
  strEndParenthesis = ')';
  strEndQuery = ');';
  strSpace = ' ';
  strComma = ', ';
  strSemiColon = ';';
  strEqual = ' = ';
  strDot = '.';

  // Prefixs
  strPrimaryKeyPrefix = 'prky';
  strFK = 'fk';
  strReferenceDNoActionUNoAction = 'dnun'; // Delete no action Update No Action
  strReferenceDCascadeUCascade = 'dcuc'; // Delete cascade Update cascade
  strReferenceDNoActionUCascade = 'dnuc'; // Delete no action Update Cascade
  strReferenceDCascadeUNoAction = 'dcun'; // Delete Cascade Update No Action

  // Prefix long
  PrefixLong = 4;

  // Property types
  ptInteger = 'integer';
  ptString15 = 'string15';
  ptString30 = 'string30';
  ptString50 = 'string50';
  ptPKeyInteger = 'pkInteger';
  ptDouble = 'double';

  // Interbase field types
  itInteger = 'integer';
  itSmallInt = 'smallint';
  itChar = 'char';
  itVarChar = 'varchar(255)';
  itVarChar15 = 'varchar(15)';
  itVarChar30 = 'varchar(30)';
  itVarChar50 = 'varchar(50)';
  itNumeric = 'numeric';
  itDate = 'date';

  // Error codes when saving
  ecInsertion = -2;
  ecUpdate = -3;

  // Messages
  strReconstruct = 'You have to re-construct the database';
  strNoConnection = 'It wasn''' + 't posible to connect to data base';
  strSaveFirst = 'The customer must be previously saved';
  strCreateTableError = 'Table creation Error. Probably tables have already been created';
  strCommitCreateTableError = 'Table creation Error: Commit';
  strParentPropListError = 'Error creating parent property list';
  strSingletonCreationError = 'It has been tried to create more than one instance of provider';
implementation

end.
