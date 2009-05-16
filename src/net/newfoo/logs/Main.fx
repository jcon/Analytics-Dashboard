package net.newfoo.logs;
/*
 * Copyright (c) 2009 Jim Connell
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import javafx.animation.transition.FadeTransition;
import javafx.geometry.*;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.Scene;
import javafx.stage.Stage;
import net.newfoo.logs.analytics.client.AnalyticsClient;
import net.newfoo.logs.analytics.client.AnalyticsException;
import net.newfoo.logs.analytics.client.GdataAnalyticsClient;
import net.newfoo.logs.analytics.client.Site;
import net.newfoo.logs.chart.DataSet;
import net.newfoo.logs.LoginForm;
import net.newfoo.logs.SiteChooser;
import net.newfoo.logs.StatsValue;
import net.newfoo.logs.ui.AnalyticsDashboardAdapter;
import javafx.scene.shape.Rectangle;

def WINDOW_HEIGHT = 560;
def WINDOW_WIDTH = 870;
def GRAPH_HEIGHT = 500;
def GRAPH_WIDTH = 650;


def GOOGLE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
def GRAPH_FORMAT = new SimpleDateFormat("MM/dd");


public class Main {
    var client: AnalyticsClient;

    var loginController: LoginController = LoginController {
        afterLogin: afterLogin
    };
    var dashboard: AnalyticsDashboardAdapter = AnalyticsDashboardAdapter{
        refresh: refresh
        login: loginController.showLogin
    };

    var site;

    public-read var ui: Node[] = bind [
        dashboard.ui,
        loginController.content
    ];

    function afterLogin(client: AnalyticsClient, site: String) {
        this.site = site;
        this.client = client;

        var range = getDateRange();
        var start = GOOGLE_FORMAT.format(range[0]);
        var end = GOOGLE_FORMAT.format(range[1]);
        dashboard.startDate.text = start;
        dashboard.endDate.text = end;

        refresh(start, end);
        dashboard.ui.visible = true;
        var trans = SwapTransition {
            inNode: dashboard.ui
            outNode: loginController.content
            duration: 400ms
        };
        trans.play();
    }

    init {
        dashboard.ui.visible = false;
        loginController.showLogin();
        var range = getDateRange();
        var start = GOOGLE_FORMAT.format(range[0]);
        var end = GOOGLE_FORMAT.format(range[1]);
        dashboard.startDate.text = start;
        dashboard.endDate.text = end;
//        refresh(start, end);
    }

    function getDateRange(): Date[] {
        var c: GregorianCalendar = GregorianCalendar{ };
        var today = c.getTime();
        c.roll(Calendar.WEEK_OF_YEAR, -1);
        return [c.getTime(), today];
    }


    function refresh(start: String, end: String): Void {
        println("refresh({start}, {end})");
        dashboard.chart.title = "{site} {formatDate(start)}-{formatDate(end)}";
        dashboard.chart.items = createDataSet(start, end);
        dashboard.topPages.values = createTopPages(start, end);
        dashboard.topReferrers.values = createTopReferrers(start, end);
    }

    function formatDate(date: String) {
        return date.substring(5).replaceAll('-', '/');
    }

    function createDataSet(start: String, end: String) {
        var count = 1;
        var visitsDataSet: DataSet = DataSet {
            pointFill: Color.rgb(0x33, 0x5b, 0x33, 1.0);
            fill: LinearGradient {
                startX: 269.84497
                startY: 50
                endX: 270.0
                endY: 480
                proportional: false
                stops: [
                    Stop {
                        offset: 0.0
                        color: Color.rgb(0x33, 0x5b, 0x33, 1.0)
                    },
                    Stop {
                        offset: 1.0
                        color: Color.rgb(0x33, 0x5b, 0x33, 0.0)
                    }
                ]
            }
        };
        var d = GOOGLE_FORMAT.parse(start);
        var calendar = new GregorianCalendar();
        calendar.setTime(d);
        var labels = [];
        for (hits in client.hits(start, end)) {
            insert
            Point2D {
                x: count++
                y: hits.getVisits()
            } into visitsDataSet.values;
            insert GRAPH_FORMAT.format(calendar.getTime()) into visitsDataSet.labels;
            calendar.roll(Calendar.DAY_OF_YEAR, 1);
            println("found {hits} hits");
        }
        println("found {sizeof visitsDataSet.values} items");
        return visitsDataSet;
    }

    function createTopPages(start: String, end: String): StatsValue[] {
        var seq: StatsValue[];
        var hits = client.topPages(start, end);
        var max = if (hits.size() < 3) hits.size() else 3;
        for (i in [0..max]) {
            var name = cropTitle(hits.get(i).<<first>>, 0, 22);
            insert StatsValue {
                value: String.valueOf(hits.get(i).second), title: name
            } into seq;
        }
        return seq;
    }
    function createTopReferrers(start: String, end: String): StatsValue[] {
        var seq: StatsValue[];
        var hits = client.topReferrers(start, end);
        var max = if (hits.size() < 3) hits.size() else 3;
        for (i in [0..max]) {
            var name = cropTitle(hits.get(i).<<first>>, 0, 22);
            insert StatsValue {
                value: String.valueOf(hits.get(i).second), title: name
            } into seq;
        }
        return seq;
    }

    function cropTitle(s: String, start: Integer, cutoff: Integer) {
        var newS = s.substring(start);
        if (newS.length() > cutoff) {
            newS = "{newS.substring(0, cutoff)} ...";
        }
        return newS;
    }

}

public function run() {
    var main = Main{ };
    Stage {
        title: "Analytics Dashboard"
        scene: Scene {
            width: WINDOW_WIDTH
            height: WINDOW_HEIGHT
            content: [
                main.ui,
            ]
        }
    }
}

