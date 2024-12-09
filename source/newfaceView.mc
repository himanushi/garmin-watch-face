using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

const BACKGROUNDS = [:I0, :I1, :I2];

class newfaceView extends WatchUi.WatchFace {
  var imageNo = 0;

  function initialize() {
    WatchFace.initialize();
  }

  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  function onShow() as Void {}

  function onUpdate(dc as Dc) as Void {
    // ここのバックグラウンドを30分ごとに変える
    if (BACKGROUNDS.size == imageNo) {
      imageNo = 0;
    }

    var background = View.findDrawableById("Background") as Bitmap;
    var image = Rez.Drawables[BACKGROUNDS[imageNo]] as Graphics.BitmapType;
    background.setBitmap(image);

    imageNo += 1;

    // Date
    var dateLabel = View.findDrawableById("DateLabel") as Text;
    var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    dateLabel.setText(now.month.format("%02d") + "/" + now.day.format("%02d"));

    // Time
    var clockTime = System.getClockTime();
    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour,
      clockTime.min.format("%02d")
    ]);
    var timeLabel = View.findDrawableById("TimeLabel") as Text;
    timeLabel.setText(timeString);

    View.onUpdate(dc);
  }

  function onHide() as Void {}

  function onExitSleep() as Void {}

  function onEnterSleep() as Void {}
}
