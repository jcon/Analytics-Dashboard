package net.newfoo.logs.analytics.client;
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

import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.stage.Stage;
import net.newfoo.logs.analytics.client.AnalyticsException;
import net.newfoo.logs.analytics.client.GdataAnalyticsClient;
import net.newfoo.logs.analytics.client.Site;
import net.newfoo.logs.LoginForm;

var v = GdataAnalyticsClient{
};
/*v.login(Constants.CLIENT_USERNAME, Constants.CLIENT_PASS);
println(v.hits("2009-04-20", "2009-04-29"));

println(v.topPages("2009-04-20", "2009-04-29"));

println(v.topReferrers("2009-04-20", "2009-04-29")); */

var sites: Site[] = [];
/*
var sitesGroup: Group = Group {
    visible: false;
    var list:SwingList = SwingList {
        items: bind [
            for (site in sites) {
                SwingListItem {
                    text: site.getName()
                    value: site.getProfileId()
                }
            }
        ]
    };
    content: [
        VBox {
            content: [
                SwingLabel {
                        text: "Choose Site"
                        font: Font.font("Georgia", FontWeight.BOLD, 24)
                },
                list,
                SwingButton {
                        text: "Choose Site"
                        action: function() {
                            var item = list.selectedItem;
                            println("choose site: {item.text} ({item.value})");
                        }
                }
            ]
        }
    ]
}; */
/*
var sitesGroup: SiteChooser = SiteChooser {
    visible: false;
    sites: bind sites
    action: function(site: String, profileId: String) {
        println("site {site} with {profileId} profileId choosen");
    }
}; */


var login: LoginForm = LoginForm {
    action: function(username: String, password: String) {
        try {
            v.login(username, password);
/*            for (s in v.getSites()) {
                insert s into sites;
            } */
            v.setProfileId(v.getSites().get(0).getProfileId());
            var hits = v.hits("2009-05-14");
            var i = 0;
            for (hit in hits) {
                println("{i++}: {hit.getVisits()}");
            }

    //        login.visible = false;
       //     sitesGroup.visible = true;
        } catch (ae:AnalyticsException) {
            login.errorMessage = "Invalid Username/Password";
        }
    }
}


Stage {
    title : "GA Login Test"
    scene: Scene {
        fill: Color.BLACK
        width: 400
        height: 400
        content: [
        //    sitesGroup,
            login
        ]
    }
}

