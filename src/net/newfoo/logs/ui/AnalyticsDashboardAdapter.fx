package net.newfoo.logs.ui;
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

import java.lang.Object;
import javafx.ext.swing.SwingButton;
import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingTextField;
import javafx.fxd.Duplicator;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.stage.Stage;
import net.newfoo.logs.chart.Chart;
import net.newfoo.logs.StatsValue;
import net.newfoo.logs.TopStats;
import net.newfoo.logs.ui.AnalyticsDashboardAdapter;
import net.newfoo.logs.ui.AnalyticsDashboardUI;

public class AnalyticsDashboardAdapter {
    public-read var ui = AnalyticsDashboardUI {
    };

    public-read var topPages: TopStats;
    public-read var topReferrers: TopStats;
    public-read var chart: Chart;
    public-read var startDate = SwingTextField{}
    public-read var endDate = SwingTextField{}
    public-read var refreshButton = SwingButton {
        text: "Refresh"
        action: function() {
            refresh(startDate.text, endDate.text);
        }
    }
    public-read var loginButton = SwingButton {
        text: "Login"
        action: function() {
            login();
        }
    }

    public-init var refresh: function(startDate: String, endDate: String): Void;
    public-init var login: function();

    init {
        topPages =  TopStats {
            title: "Top Pages"
            ui: ui.pages
            values: [
                StatsValue {
                    value: "99", title: "Performance Tun..."
                },
                StatsValue {
                    value: "78", title: "Game Design..."
                },
                StatsValue {
                    value: "20", title: "Google App..."
                }
                StatsValue {
                    value: "20", title: "JavaFX..."
                }
            ]
        }
        var referrers = Duplicator.duplicate(ui.pages) as Group;
        topReferrers =  TopStats {
            title: "Top Referrers"
            ui: referrers;
            values: [
                StatsValue {
                    value: "100", title: "google.com"
                },
                StatsValue {
                    value: "88", title: "learnjavafx.typ..."
                },
                StatsValue {
                    value: "46", title: "javafx.com"
                }
                StatsValue {
                    value: "35", title: "(direct)"
                }
            ]
        }
        align(ui.referrer, referrers);
        insert referrers into (ui.stats as Group).content;
        ui.referrer.visible = false;

        chart = Chart {
            ui: ui.chartContainer as Group
        }

        insert startDate into ui._root.content;
        insert endDate into ui._root.content;
        insert loginButton into ui._root.content;
        insert refreshButton into ui._root.content;

        overwrite(ui.startDate, startDate);
        overwrite(ui.endDate, endDate);
        overwrite(ui.loginButton, loginButton);
        overwrite(ui.refreshButton, refreshButton);

        ui.graphRangeLine.visible = false;
    }

    function overwrite(dest: Node, target: SwingComponent) {
        var d = dest.boundsInScene;
        target.width = d.width;
        target.height = d.height;
        align(dest, target);
    }


    function align(dest: Node, target: Node) {
        var d = dest.boundsInScene;
        var t = target.boundsInScene;

        var leftX = d.minX + dest.translateX;
        var topY = d.minY + dest.translateY;

        target.translateX = leftX - t.minX;
        target.translateY = topY - t.minY;
    }



}

public function run() {
    var ui = AnalyticsDashboardAdapter{ };
    Stage {
        title: "MyApp"
        scene: Scene {
            width: 900
            height: 800
            content: [
                ui.ui
            ]
        }
    }
}

