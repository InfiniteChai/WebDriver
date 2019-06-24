module WebDriver

using PyCall

struct Driver
    o::PyObject
end
PyObject(x::Driver) = x.o

struct WebElement
    o::PyObject
end
PyObject(x::WebElement) = x.o

function init_chrome(;headless = true)
    wd = pyimport("selenium.webdriver")
    options = wd.ChromeOptions()
    options.headless = headless
    Driver(wd.Chrome(options=options))
end

struct ActionChain
    o::PyObject
end

function ActionChain(x::Driver)
    wd = pyimport("selenium.webdriver")
    ActionChain(wd.ActionChains(x.o))
end

PyObject(x::ActionChain) = x.o

get(driver::Driver, url) = driver.o.get(url)
quit(driver::Driver) = driver.o.quit()
refresh(driver::Driver) = driver.o.refresh()

end # module
