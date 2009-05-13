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

import javafx.ext.swing.SwingButton;
import javafx.ext.swing.SwingList;
import javafx.ext.swing.SwingListItem;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import net.newfoo.logs.analytics.client.Site;

public class SiteChooser extends CustomNode {
    def LIST_WIDTH = .75;
    public var sites: Site[];
    public-init var action: function(site: String, profileId: String);

    var list:SwingList = SwingList {
        width: bind parent.boundsInLocal.width * LIST_WIDTH
        enabled: true
        items: bind [
            for (site in sites) {
                SwingListItem {
                    text: site.getName()
                    value: site.getProfileId()
                }
            }
        ]

    };

    override function requestFocus() {
        list.requestFocus();
        super.requestFocus();
    }

    public override function create(): Node {
        return Group {
            translateX: bind (parent.boundsInLocal.width * (1 - LIST_WIDTH)) / 2
            translateY: bind (parent.boundsInLocal.height * (1 - LIST_WIDTH)) / 2
            content: [
                VBox {
                    content: [
                        Text {
                            textOrigin: TextOrigin.TOP
                            fill: Color.WHITE
                            content: "Choose Site"
                            font: Font.font("Georgia", FontWeight.BOLD, 24)
                        },
                        list,
                        SwingButton {
                            text: "Choose Site"
                            action: function() {
                                var item = list.selectedItem;
                                println("choose site: {item.text} ({item.value})");
                                action(item.text, item.value as String);
                            }
                        }
                    ]
                }
            ]
        };
    }
}
