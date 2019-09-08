package test.groovy


import org.junit.Before
import org.junit.Test

import static org.junit.Assert.assertEquals

class RandomUnitTest {

    @Before
    void setUp() {
        // load toAlphanumeric
        //def pip = loadScript("vars/SamplePipeline.groovy")
    }

    @Test
    public void test1() {
        assertEquals "dannel", "dannel"
    }

    @Test
    void test2() {
        assertEquals 100, 100
    }
}
