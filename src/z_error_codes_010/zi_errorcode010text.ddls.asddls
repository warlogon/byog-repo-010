@EndUserText.label: 'Error Code 010 Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity ZI_ErrorCode010Text
  as select from ZERRCODET_010
  association [1..1] to ZI_ErrorCode010_S as _ErrorCode010All on $projection.SingletonID = _ErrorCode010All.SingletonID
  association to parent ZI_ErrorCode010 as _ErrorCode010 on $projection.ErrorCode = _ErrorCode010.ErrorCode
  association [0..*] to I_LanguageText as _LanguageText on $projection.Langu = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key LANGU as Langu,
  key ERROR_CODE as ErrorCode,
  @Semantics.text: true
  DESCRIPTION as Description,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _ErrorCode010All,
  _ErrorCode010,
  _LanguageText
  
}
