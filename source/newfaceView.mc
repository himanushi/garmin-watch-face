using Toybox.ActivityMonitor;
using Toybox.Time.Gregorian;
using Toybox.Math;
using Toybox.WatchUi as Ui;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class newfaceView extends WatchUi.WatchFace {
  const BACKGROUNDS = [:I0, :I1, :I2];
  var imageSchedule = [];
  var isFirst = true;
  var mBurnInProtectionChangedSinceLastDraw = false;
  var mIsBurnInProtection = false;

  function initialize() {
    WatchFace.initialize();
    isFirst = true;

    // Precompute schedule
    var backgroundsCount = BACKGROUNDS.size();
    for (var i = 0; i < 48; i++) {
      imageSchedule.add(Math.ceil(i % backgroundsCount));
    }
  }

  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  function onUpdate(dc as Dc) as Void {
    if (mBurnInProtectionChangedSinceLastDraw) {
      mBurnInProtectionChangedSinceLastDraw = false;
      if (mIsBurnInProtection) {
        setLayout(Rez.Layouts.AlwaysOn(dc));
        updateDataForAlwaysOn();
      } else {
        setLayout(Rez.Layouts.WatchFace(dc));
        updateData();
      }
    }

    if (!mIsBurnInProtection) {
      updateData();
    }

    isFirst = false;
    View.onUpdate(dc);
  }

  function updateData() as Void {
    var clockTime = System.getClockTime();
    var currentMinutes = clockTime.hour * 60 + clockTime.min;

    // Determine which interval of the day we're in
    var interval = Math.floor(currentMinutes / 30);
    var imageIndex = imageSchedule[interval];

    // Set the background image
    var background = View.findDrawableById("Background") as Bitmap;
    var image = Rez.Drawables[BACKGROUNDS[imageIndex]] as Graphics.BitmapType;
    background.setBitmap(image);

    // Display date and time
    var dateLabel = View.findDrawableById("DateLabel") as Text;
    var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    dateLabel.setText(now.month.format("%02d") + "/" + now.day.format("%02d"));

    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour,
      clockTime.min.format("%02d")
    ]);
    var timeLabel = View.findDrawableById("TimeLabel") as Text;
    timeLabel.setText(timeString);

    // Display data1 (steps)
    var data1Label = View.findDrawableById("Data1Label") as Text;
    var info = ActivityMonitor.getInfo();
    data1Label.setText(info.steps.toString());

    // Display data2 (heart rate)
    var data2Label = View.findDrawableById("Data2Label") as Text;
    var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);
    var previous = hrIterator.next();
    data2Label.setText(previous.heartRate.toString());

    // Display data3 (battery days)
    var data3Label = View.findDrawableById("Data3Label") as Text;
    var stats = System.getSystemStats();
    data3Label.setText(Lang.format("$1$d", [stats.batteryInDays.format("%d")]));
  }

  function updateDataForAlwaysOn() as Void {
    var clockTime = System.getClockTime();
    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour,
      clockTime.min.format("%02d")
    ]);
    var timeLabel = View.findDrawableById("TimeLabel") as Text;
    timeLabel.setText(timeString);
  }
}
