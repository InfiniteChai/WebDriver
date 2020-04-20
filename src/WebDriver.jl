module WebDriver

using PyCall

export init_chrome, with_chrome

struct Driver
    o::PyObject
end
PyObject(x::Driver) = x.o

struct WebElement
    o::PyObject
end
PyObject(x::WebElement) = x.o

logging = pyimport_conda("logging", "logging")
rc = pyimport_conda("selenium.webdriver.remote.remote_connection", "selenium")
rc.LOGGER.setLevel(logging.ERROR)

function init_chrome(;headless = true)
    wd = pyimport_conda("selenium.webdriver", "selenium")
    options = wd.ChromeOptions()
    options.headless = headless
    options.add_experimental_option("excludeSwitches", ["enable-logging"])
    Driver(wd.Chrome(options=options))
end

function with_chrome(fn; headless = true)
    d = init_chrome(headless = headless)
    try
        fn(d)
    finally
        quit(d)
    end
end

struct ActionChain
    o::PyObject
end

function ActionChain(x::Driver)
    wd = pyimport_conda("selenium.webdriver", "selenium")
    ActionChain(wd.ActionChains(x.o))
end

PyObject(x::ActionChain) = x.o

get(driver::Driver, url) = driver.o.get(url)
quit(driver::Driver) = driver.o.quit()
refresh(driver::Driver) = driver.o.refresh()
findone(driver::Driver, xpath) = WebElement(driver.o.find_element_by_xpath(xpath))
findall(driver::Driver, xpath) = map(WebElement, driver.o.find_elements_by_xpath(xpath))
execute_script(driver::Driver, script::String, args...) = driver.o.execute_script(script, args...)
findone(element::WebElement, xpath) = WebElement(element.o.find_element_by_xpath(xpath))
findall(element::WebElement, xpath) = map(WebElement, element.o.find_elements_by_xpath(xpath))
attribute(element::WebElement, name) = element.o.get_attribute(name)
text(element::WebElement) = element.o.text
Base.getindex(element::WebElement, name) = attribute(element, name)

end # module
