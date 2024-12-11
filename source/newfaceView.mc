using Toybox.ActivityMonitor;
using Toybox.Time.Gregorian;
using Toybox.Math;
using Toybox.WatchUi as Ui;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

const BACKGROUNDS = [:I0, :I1, :I2];

class newfaceView extends WatchUi.WatchFace {
  var lastUpdateTime = 0;

  function initialize() {
    WatchFace.initialize();
  }

  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  function onShow() as Void {}

  function onUpdate(dc as Dc) as Void {
    var clockTime = System.getClockTime();
    var currentMinutes = clockTime.hour * 60 + clockTime.min;

    // 30分ごとに背景画像を変更
    var minutes = 30;
    if (
      Math.floor(currentMinutes / minutes) !=
      Math.floor(lastUpdateTime / minutes)
    ) {
      lastUpdateTime = currentMinutes;

      Math.srand(System.getTimer());
      var randomIndex = Math.rand() % BACKGROUNDS.size();
      var background = View.findDrawableById("Background") as Bitmap;
      var image =
        Rez.Drawables[BACKGROUNDS[randomIndex]] as Graphics.BitmapType;
      background.setBitmap(image);
    }

    // 日付の表示
    var dateLabel = View.findDrawableById("DateLabel") as Text;
    var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    dateLabel.setText(now.month.format("%02d") + "/" + now.day.format("%02d"));

    // 時刻の表示
    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour,
      clockTime.min.format("%02d")
    ]);
    var timeLabel = View.findDrawableById("TimeLabel") as Text;
    timeLabel.setText(timeString);

    // データ1の表示
    var data1Label = View.findDrawableById("Data1Label") as Text;
    var info = ActivityMonitor.getInfo();
    data1Label.setText(info.steps.toString());

    // データ2の表示
    var data2Label = View.findDrawableById("Data2Label") as Text;
    var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);
    var previous = hrIterator.next();
    data2Label.setText(previous.heartRate.toString());

    // データ3の表示
    var data3Label = View.findDrawableById("Data3Label") as Text;
    data3Label.setText(info.steps.toString());
    var stats = System.getSystemStats();
    data3Label.setText(Lang.format("$1$d", [stats.batteryInDays.format("%d")]));

    View.onUpdate(dc);
  }

  function onHide() as Void {}

  function onExitSleep() as Void {}

  function onEnterSleep() as Void {}
}
