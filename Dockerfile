FROM mseki/ruby-opencv:latest
MAINTAINER seki <m_seki@mac.com>

ADD data /data/

ADD src/abcd.rb /

CMD [ "ruby", "abcd.rb", "druby://:50151" ]
