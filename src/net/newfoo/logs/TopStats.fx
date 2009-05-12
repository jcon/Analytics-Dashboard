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

import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.text.Text;

public class TopStats {
    def PADDING = 5;

    public var title: String on replace {
        titleValue.content = title;
    }

    public var values: StatsValue[] on replace {
        setValues();
    }

    public var maxX: Number;

    public-init var ui: Node on replace {
        if (ui != null) {
            titleValue = getText(ui.lookup("statsTitle"));
            rows = ui.lookup("statsRows") as Group;
            column1 = ui.lookup("statsColumn1") as Group;
        }
    }

    var column1: Group;
    var rows: Group;
    var valueMaxX: Number = 0;

    var titleValue: Text;

    init {
        titleValue.content = title;
        setValues();
    }

    function setValues() {
        var max = if (sizeof values < 3) sizeof values else 3;
        for (i in [0..max]) {
            (rows.content[2*i] as Text).content = values[i].title;
            var value = (rows.content[2*i + 1] as Text);
            value.content = values[i].value;
            var newX = column1.content[i].boundsInLocal.maxX - value.boundsInLocal.width - PADDING;
            //println("newX is {newX} {value.boundsInLocal.minY}")
            var tX = bind newX - value.boundsInLocal.minX;
            value.translateX = tX;
        }
    }

    function getText(node: Node): Text {
        if (node instanceof Group) {
            var g = node as Group;
            var text = g.content[1] as Text;
            return text;
        } else {
            return null;
        }
    }
}