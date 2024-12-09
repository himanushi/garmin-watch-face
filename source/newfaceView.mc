using Toybox.WatchUi as Ui;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

var font;

class newfaceView extends WatchUi.WatchFace {
  function initialize() {
    WatchFace.initialize();
  }

  function onLayout(dc as Dc) as Void {
    font = Ui.loadResource(Rez.Fonts.Mother2);
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  function onShow() as Void {}

  function onUpdate(dc as Dc) as Void {
    var clockTime = System.getClockTime();
    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour,
      clockTime.min.format("%02d")
    ]);

    var view = View.findDrawableById("TimeLabel") as Text;
    view.setText(timeString);
    view.setFont(font);

    View.onUpdate(dc);
  }

  function onHide() as Void {}

  function onExitSleep() as Void {}

  function onEnterSleep() as Void {}
}
