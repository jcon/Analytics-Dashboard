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

import com.google.gdata.util.common.base.Pair;
import java.util.List;

public interface AnalyticsClient {
    /** Authenticate a user */
    void login(String user, String pass);

    /** After logging in, provide the list of sites to which the
        user is subscribed. */
    List<Site> getSites();

    /** Set a valid GA profileID obtained from one of the sites in getSites() */
    void setProfileId(String profileId);

    /** provide a list of hits for a given date range */
    List<TimeEntry> hits(String start, String end);

    /** list pages ordered by # of visitors for date range */
    List<Pair<String, Long>> topPages(String start, String end);

    /** list referrers ordered by # visits for date range */
    List<Pair<String, Long>> topReferrers(String start, String end);

}
