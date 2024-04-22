@EndUserText.label: 'Maintain Error Code 010'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_ErrorCode010
  as projection on ZI_ErrorCode010
{
  key ErrorCode,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @ObjectModel.text.element: [ 'ConfigurationDeprecation_Text' ]
  ConfigDeprecationCode,
  @Consumption.hidden: true
  SingletonID,
  _ErrorCode010All : redirected to parent ZC_ErrorCode010_S,
  ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText.ConfignDeprecationCodeName as ConfigurationDeprecation_Text : localized,
  _ErrorCode010Text : redirected to composition child ZC_ErrorCode010Text,
  _ErrorCode010Text.Description : localized
  
}
