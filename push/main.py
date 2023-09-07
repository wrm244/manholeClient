import jpush
import common
# please put your app_key and master_secret here
app_key = u'd322fd7dc53f6519184cdbae'
master_secret = u'2a344236e5346d221f62edf7'
_jpush = jpush.JPush(app_key, master_secret) #初始化jpush

push = _jpush.create_push()
device = _jpush.create_device()
reg_id = '160a3797c91abf1e4c6' #绑定了我的唯一设备

# if you set the logging level to "DEBUG",it will show the debug logging.
# _jpush.set_logging("DEBUG")
push.audience = jpush.registration_id(reg_id)

push.notification = jpush.notification(alert="井盖不见了")

push.platform = jpush.all_

# 开始推送
try:
    response=push.send()
except common.Unauthorized:
    raise common.Unauthorized("Unauthorized")
except common.APIConnectionException:
    raise common.APIConnectionException("conn error")
except common.JPushFailure:
    print ("JPushFailure")
except:
    print ("Exception")