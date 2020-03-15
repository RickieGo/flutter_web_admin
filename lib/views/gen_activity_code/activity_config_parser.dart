import 'package:mt_flutter/views/gen_activity_code/activity_config.dart';

enum PrintLoadType {
  PrintLoadType_Normal,
  PrintLoadType_Array,
  PrintLoadType_Map,
}

class ActConfigParser {
  static Map<String, dynamic> mActivityValue;
  static StringBuffer cppOut = StringBuffer();
  static StringBuffer headOut = StringBuffer();
  static Set<String> typeInfoDefine = Set<String>();
  static Set<String> cacheDefine = Set<String>();
  static String sActName;

  static void reset() {
    cppOut.clear();
    headOut.clear();
    typeInfoDefine.clear();
    cacheDefine.clear();
  }

  static ActField createSubField(Map<String, dynamic> sFieldValue) {
    if (sFieldValue['type'] == 'map') {
      return ActMapField();
    } else if (sFieldValue['type'] == 'array') {
      return ActArrayField();
    } else if (sFieldValue['type'] == 'number' ||
        sFieldValue['type'] == 'select') {
      return ActNumberField();
    } else if (sFieldValue['type'] == 'datetime') {
      return ActDateTimeField();
    } else if (sFieldValue['type'] == 'daytime') {
      return ActTimeField();
    } else if (sFieldValue['type'] == 'text' ||
        sFieldValue['type'] == 'midtext' ||
        sFieldValue['type'] == 'longtext') {
      if (sFieldValue['parser'] == 'parseItemNumList')
        return ActItemListField();
      if (sFieldValue['parser'] == 'parseStrList') return ActStrListField();
      if (sFieldValue['parser'] == 'parseIdList') return ActIdListField();

      return ActStringField();
    } else if (sFieldValue['type'] == 'textarea') {
      if (sFieldValue['subFieldOption'] == mActivityValue['taskConfig'])
        return ActTaskField();
      if (sFieldValue['subFieldOption'] == mActivityValue['taskGroupConfig'])
        return ActTaskGroupField();
      if (sFieldValue['subFieldOption'] == mActivityValue['drawRewardConfig'])
        return ActDrawField();
      return ActTextAreaField();
    }
    return null;
  }

  static Set<String> internalType = {
    "uint32_t",
    "string",
    "vector<uint32_t>",
    "vector<string>",
    "IDNumVec",
    "ActCfgTask",
    "ActCfgDrawReward",
  };

  ActConfigParser();
  ActField actField = ActField();
  void parse(Map<String, dynamic> mJsonData, String sJsonValueName) {
    if (!mJsonData.containsKey(sJsonValueName)) return;
    actField.setSubFieldStructName('ActCfg${ActConfigParser.sActName}');
    actField.parse(null, sActName, mJsonData[sJsonValueName], sJsonValueName);
  }

  bool isContainSubField(Type T) {
    return actField.isContainSubField(T);
  }

  //
  void printTypeDefine() {
    //检查时都需要定义新的类型
    actField.printTypeDefine();
  }

  void printSubLoadCode() {
    actField.printLoadArray();
  }

  void printSourceFile() {
    headOut.write('''
#include "Activity$sActName.h"
#include "ActivityRegister.h"
#include "Common/ErrorDefine.h"
#include "Common/ProtoActivity.h"
#include "Logic/Role.h"
#include "Logic/LogStat.h"
#include "Table/TableActivity.h"
#include "Base/TimeHelper.h"

namespace MTTD_Act_$sActName
{
int32_t parserConfig$sActName(uint32_t iActivityId, const Json::Value &jsonComm, const Json::Value &jsonServer, ActCfg$sActName *pActivityConfig)
{
    (void)iActivityId;
    (void)jsonComm;
    (void)jsonServer;
    ''');

    printSubLoadCode();

    headOut.write('''
    return 0;
}
        ''');

    headOut.write('''
int32_t getStatus$sActName(Role &role, uint32_t iActivityId, MTTDProto::CmdAct${sActName}_Status &stStatus)`)
{
   ''');

    if (isContainSubField(ActTaskField)) {
      headOut
          .writeln('    role.act$sActName.checkRefreshActTask(iActivityId);');
    }
    headOut.write('''
    return role.act$sActName.getStatus(iActivityId, stStatus);
}
REGISTER_ACTIVITY(MTTD::ActivityType_$sActName, parserConfig$sActName, NULL, getStatus$sActName);
        ''');

    headOut.write('''
int32_t Activity$sActName::getStatus(uint32_t iActivityId, MTTDProto::CmdAct${sActName}_Status &stStatus)
{
    const ActCfg$sActName* pActConfig = getActConfig(iActivityId);
    if(pActConfig == NULL)
    {
        return MTTD::Error_NoSuch_Activity;
    }
    MTTDCache::CacheAct$sActName* pActCache = getActCache(iActivityId);
	  if (NULL == pActCache)
	  {
		  return NULL;
	  }
    stStatus.iActivityId = iActivityId;`
);
        ''');

    for (var item in cacheDefine) {
      headOut.writeln('    stStatus.$item = pActCache->$item');
    }

    if (isContainSubField(ActTaskField)) {
      headOut.writeln('    packTaskCmdData(iActivityId,stStatus.mTaskData);');
    }

    headOut.writeln('    return 0');
    headOut.writeln('}');

    headOut.write('''

const ActCfg$sActName* Activity$sActName::getActConfig(uint32_t iActivityId,bool bCheckConstrain)
{
    const ActivityTableData* pActivityTable = TABLE_ACTIVITY->getActivity(iActivityId);
    if (NULL == pActivityTable)
    {
        return NULL;
    }
    if (pActivityTable->iActivityType != MTTD::ActivityType_$sActName)
    {
        return NULL;
    }
	if(bCheckConstrain)
	{
		int32_t iRet = checkActivityConstrain(*pActivityTable);
		if (iRet != 0)
		{
			return NULL;
		}		
	}

    return pActivityTable->getConfig<ActCfg$sActName>();
}

MTTDCache::CacheAct$sActName* Activity$sActName::getActCache(uint32_t iActivityId,bool bCreate)
{
    MTTDCache::CacheAct$sActName* pCacheData = findActivity(getCacheActivity().vAct$sActName, iActivityId);
    if (pCacheData == NULL)
    {
        if (bCreate) {
            const ActCfg$sActName* pActConfig = getActConfig(iActivityId);
            if(pActConfig == NULL)
            {
                return NULL;
            }
            
            MTTDCache::CacheAct$sActName stCacheData;
            stCacheData.iActivityId = iActivityId;
            getCacheActivity().vAct$sActName.push_back(stCacheData);
            return &getCacheActivity().vAct$sActName.back();
        }
        return NULL;
    }
    else
    {
        return pCacheData;
    }
}

//@@cmdHandleFunc@@//
    ''');

    if (isContainSubField(ActTaskField)) {
      headOut.write('''
//任务相关
MTTDCache::CacheActTask* Activity$sActName::onGetTaskCache(uint32_t iActivityId)
{
	MTTDCache::CacheAct$sActName* pActCache = getActCache(iActivityId);
	if (NULL == pActCache)
	{
		return NULL;
	}
	return &(pActCache->stActTaskData);
}

const ActCfgTask* Activity$sActName::onGetTaskConfig(uint32_t iActivityId)
{
	const ActCfg$sActName* pActConfig = getActConfig(iActivityId);
	if (NULL == pActConfig)
	{
		return NULL;
	}
	return  &(pActConfig->stTaskConfig);
}
      ''');
    }
  }

  void printHeadFile() {
    headOut.write('''
#pragma once
#include <vector>
#include <map>
#include <string>
#include "util/util_singleton.h
#include "ActivityLogic.h"
#include Common/ActivityType.h
namespace MTTDProto {
  class CmdAct${sActName}_Status;
  //@@actCmdNameSpace@@//
};

namespace MTTDCache {
  class CacheAct$sActName;
};
''');

    printTypeDefine();

    headOut.write('''
class Activity$sActName : public ActivityLogic
{
public:
     ''');
    if (isContainSubField(ActTaskField)) {
      headOut.write(
          'Activity$sActName(Role &role) : ActivityLogic(role) {addTaskLogic(MTTD::ActivityType_$sActName,this); }');
    } else {
      headOut.write('Activity$sActName(Role &role) : ActivityLogic(role) {}');
    }

    headOut.write('''
    int32_t getStatus(uint32_t iActivityId, MTTDProto::CmdAct${sActName}_Status &stStatus);
    const ActCfg$sActName* getActConfig(uint32_t iActivityId,bool bCheckConstrain = true);
    MTTDCache::CacheAct$sActName* getActCache(uint32_t iActivityId,bool bCreate = true); 
    //@@cmdHandleDefine@@//

    ''');

    if (isContainSubField(ActTaskField)) {
      headOut.write('''
    //任务相关
    MTTDCache::CacheActTask* onGetTaskCache(uint32_t iActivityId);
    const ActCfgTask* onGetTaskConfig(uint32_t iActivityId);`);
};
    ''');
    }
  }
}
