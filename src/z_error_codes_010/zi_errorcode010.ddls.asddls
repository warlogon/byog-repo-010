@EndUserText.label: 'Error Code 010'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_ErrorCode010
  as select from ZERRCODE_010
  association to parent ZI_ErrorCode010_S as _ErrorCode010All on $projection.SingletonID = _ErrorCode010All.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
  composition [0..*] of ZI_ErrorCode010Text as _ErrorCode010Text
{
  key ERROR_CODE as ErrorCode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  CONFIGDEPRECATIONCODE as ConfigDeprecationCode,
  1 as SingletonID,
  _ErrorCode010All,
  _ErrorCode010Text,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
